###############################################################################
#
# Swap related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.modules.nixos.core = { lib, config, ... }:
  {
    config = {
      fileSystems."/swap".options = [ "compress=none" "noatime" ];

      swapDevices = [ {
        device = "/swap/swapfile";
        size = config.filesystem.swapSize;
      } ];
    };
  };
}

