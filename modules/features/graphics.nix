###############################################################################
#
# Hardware accelerated graphics generic config.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.graphics = { lib, config, pkgs, ...}:
  {
    config = {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
