###############################################################################
#
# Impermanence setup.
# 
# The idea is to wipe /root at every boot to keep things clean
# except for directories and files declared persistents
# Needs the impermanence flake
#
# Based on so many sources, the latest being
# https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/persist.nix
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.impermanence = { lib, config, pkgs, ... }: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
    scriptsDir = ../../scripts;
  in
  {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    config = {
      features.impermanence.enable = true; # So other modules know

      # Adding options to the filesystems
      fileSystems = let
        neededForBoot = true;
        options = [ "compress=zstd" "noatime" ];
        fullOptions = { inherit neededForBoot options; };
      in
      {
        "/".options = options;

        "/home" = fullOptions;
        "/home/.snapshots".options = options;

        "/nix".options = [ "noatime" ];

        "/persist" = fullOptions;
        "/persist/.snapshots" = fullOptions;

        "/var/local".options = options;
        "/var/local/.snapshots".options = options;

        "/var/log" = fullOptions;
      };

      
      # Rollback routine on every boot
      # ------------------------------
      boot.initrd.systemd.services.rollback = {
        description = "Rollback BTRFS root and home subvolumes to a pristine state";
        wantedBy = [ "initrd.target" ];
        requires = [ "initrd-root-device.target" ];
        after = [ "initrd-root-device.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = builtins.readFile "${scriptsDir}/rollback.sh";
      };

      environment = {
        # Script to find what needs to persist
        # ------------------------------------
        systemPackages = lib.mkBefore [
          ( pkgs.writeShellApplication {
            name = "differences";
            runtimeInputs = [ pkgs.btrfs-progs ];
            text = builtins.readFile "${scriptsDir}/differences.sh";
          } )

          ( let
              ignore = lib.strings.join "|" [
                ".cache"
                "/etc/(.clean|group|passwd|resolv.conf|shadow|subgid|subuid|sudoers|.updated)"
                "/root/.nix-channels"
                "/tmp/.X0-lock"
                "/var/lib/(lastlog/lastlog2.db|logrotate.status|NetworkManager)"
              ];
            in
              pkgs.writeShellScriptBin "differences-root" ''
                exec differences "root" "" "${ignore}"
              '' )

          ( let
              ignore = lib.strings.join "|" [];
            in
              pkgs.writeShellScriptBin "differences-home" ''
                exec differences "home/active" "home" "${ignore}"
              '' )
        ];


        # Now, opt-in what needs to persist
        # ---------------------------------
        persistence."/persist" = {
          hideMounts = true;             # What's it doing really?

          # System-wide persistent directories and files
          directories = [
            # ...
          ]
          ++ lib.forEach [                   # /etc/...
            "mullvad-vpn"
            "NetworkManager/system-connections"
            "nixos"
            "ssh"
            "tuned" ] (x: "/etc/${x}")
          ++ lib.forEach [                   # /var/lib/...
            "bluetooth"
            "nixos"
            "tailscale"
            "upower" ] (x: "/var/lib/${x}")
          ++ lib.forEach [                   # /var/cache/...
            "mullvad-vpn" ] (x: "/var/cache/${x}");

          files = [
            "/etc/machine-id"
            "/root/.local/share/nix/trusted-settings.json"
          ]
          ++ lib.forEach [
            "secret_key"
            "seen-bssids"
            "timestamps"
          ] (x: "/var/lib/NetworkManager/${x}");


          # Persistant home subdirectories and files common to all users
          users = lib.listToAttrs ( map ( username: {
            name = username; value = {
              directories = [
                ".gnupg"                         # PGP utility
                ".local/share/keyrings"          # Gnome keyring
                ".mullvad"                       # VPN
                ".ssh"                           # Obvious, innit?
                "Data"                           # Vaults, documents, etc
              ];

              files = [
                ".local/share/nix/trusted-settings.json"
                # ".zshrc"
                ".zsh_history"
              ];
            };
          } ) ( lib.lists.unique ( users ) ) );
        };
      };


      # Persist systemd services' tmp files
      # systemd.tmpfiles.rules = [
      #   "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      #   "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      #   "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
      # ];


      # Rollback results in sudo lectures after each reboot
      # ---------------------------------------------------
      security.sudo.extraConfig = ''
        Defaults lecture = never
      '';
    };
  };
}
