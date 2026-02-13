###############################################################################
#
# Hibernation config.
#
# Resources:
# - https://nixos.wiki/wiki/Hibernation
#
# Next steps:
# -----------
# - @todo Find out why I have this error when resuming from hibernation
#   "BTRFS error: failed to open device for path /dev/mapper/cryptroot with flags 0x3: -16"
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.hibernation = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
  in
  {
    # Related options and default values definition
    options.nouveauxParadigmes.hibernation = {
      enable = lib.mkEnableOption "Enable hibernation? Defaults to false.";

      resume = {
        device = lib.mkOption {
          type = lib.types.str;
          default = "/dev/mapper/cryptroot";
          description = "Which device to resume from after hibernation? \
                         Defaults to /dev/mapper/cryptroot";
        };

        offset = lib.mkOption {
          type = lib.types.str;
          default = "0";
          description = "Offset to resume after hibernation. \
                         Defaults to 0. To find the value, use: \
                         sudo btrfs inspect-internal map-swapfile -r /swap/swapfile";
        };
      };
    };

    config = lib.mkIf cfg.hibernation.enable {
      boot.kernelParams = [
        "resume=${cfg.hibernation.resume.device}"
        "resume_offset=${cfg.hibernation.resume.offset}"
      ];

      # For hibernation to work, swap size needs to be at least ram size
      # nouveauxParadigmes.swapSize = cfg.ramSize + 1024;
      
      services = {
        # Lid and powerKey events
        logind.settings.Login = {
          HandleLidSwitch = "hibernate"; # "suspend-then-hibernate"
          HandlePowerKey = "hibernate";
        };

        upower = lib.mkIf config.services.upower.enable {
          criticalPowerAction = "Hibernate";
        };
      };

      # https://wiki.nixos.org/wiki/Power_Management
      systemd.sleep.extraConfig = ''
        HibernateDelaySec=15m
      '';
    };
  };
}
