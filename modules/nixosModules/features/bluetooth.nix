###############################################################################
#
# Bluetooth generic config.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.bluetooth = { lib, config, ...}:
  {
    config = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        # settings.General.Experimental = true;
      };

      services.blueman.enable = config.features.desktop.enable;
    };
  };
}
