###############################################################################
# 
# Impermanence setup
# The idea is to wipe /root at every boot to keep things clean
# except for directories and files declared persistents
# Needs the impermanence flake
#
# Based on so many sources, the latest being
# https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/persist.nix
#
###############################################################################

{ config, lib, pkgs, ... }: let
  differences = pkgs.writeShellApplication {
    name = "differences";
    runtimeInputs = [ pkgs.btrfs-progs ];
    text = builtins.readFile ../scripts/differences.sh;
  };

  # isNvme = lib.strings.hasInfix "nvme" config.nouveauxParadigmes.rootDisk;
  # deviceName = ${config.nouveauxParadigmeS.rootDisk} lib.strings.optionalString isNvme "p";

  # @todo Make this more versatile regarding the disk type etc
  requiresAfter = if config.nouveauxParadigmes.encryption.enable
    then "systemd-cryptsetup@cryptroot.service"
    else "dev-nvme0n1p2.device";
in
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    impermanence.enable = lib.mkEnableOption "Use impermanence? Defaults to false.";
  };

  
  config = lib.mkIf config.nouveauxParadigmes.impermanence.enable {
    # Rollback routine on every boot
    # ------------------------------
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root and home subvolumes to a pristine state";
      wantedBy    = [ "initrd.target" ];
      requires    = [ requiresAfter ];
      after       = [ requiresAfter ];
      before      = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type             = "oneshot";
      script = builtins.readFile ../scripts/rollback.sh;
    };


    environment = {
      # Script to find what needs to persist
      # ------------------------------------
      systemPackages = lib.mkBefore [
        differences
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
          # "NetworkManager"
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
        users = lib.forEach [ config.nouveauxParadigmes.users.main ]
                           ++ config.nouveauxParadigmes.users.others ( x:
          "${x}" = {
            directories = [
              ".gnupg"                         # PGP utility
              ".local/share/keyrings"          # Gnome keyring
              ".mullvad"                       # VPN
              ".ssh"                           # Obvious, innit?
              # "Data"                           # Vaults, documents, etc
            ];
          
            files = [
              ".local/share/nix/trusted-settings.json"
              # ".zshrc"
              ".zsh_history"
            ];
          }
        );
        
        # users.${config.nouveauxParadigmes.users.main} = {
        #   directories = [
        #     ".gnupg"                         # PGP utility
        #     ".local/share/keyrings"          # Gnome keyring
        #     ".mullvad"                       # VPN
        #     ".ssh"                           # Obvious, innit?
        #     # "Data"                           # Vaults, documents, etc
        #   ];
          
        #   files = [
        #     ".local/share/nix/trusted-settings.json"
        #     # ".zshrc"
        #     ".zsh_history"
        #   ];
        # };
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


    # Allow non-root users
    # --------------------
    programs.fuse.userAllowOther = true;
  };
}
