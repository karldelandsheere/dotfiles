###############################################################################
#
# Hibernation config.
#
# Resources:
# - https://nixos.wiki/wiki/Hibernation
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.hibernation = { lib, config, ... }:
  {
    config = {
      features.hibernation.enable = true; # So other modules know
      
      boot.kernelParams = [
        "resume=${config.filesystem.root}"
        "resume_offset=${config.features.hibernation.resumeOffset}"
      ];

      # For hibernation to work, swap size needs to be at least ram size
      # @todo Add a check for swapSize to be bigger than ram size
      #  filesystem.swapSize = cfg.ramSize + 1024;
      
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
