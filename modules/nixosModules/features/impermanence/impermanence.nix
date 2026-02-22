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
  flake.nixosModules.impermanence = { lib, config, pkgs, ... }:
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
        script = builtins.readFile ./rollback.sh;
      };

      environment = {
        # Script to find what needs to persist
        # ------------------------------------
        systemPackages = lib.mkBefore [
          ( pkgs.writeShellApplication {
            name = "differences";
            runtimeInputs = [ pkgs.btrfs-progs ];
            text = builtins.readFile ./differences.sh;
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
        persistence."/persist".hideMounts = true;  # What's it doing really?
      };


      # Rollback results in sudo lectures after each reboot
      # ---------------------------------------------------
      security.sudo.extraConfig = ''
        Defaults lecture = never
      '';
    };
  };
}
