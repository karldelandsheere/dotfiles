###############################################################################
#
# Hardware accelerated graphics generic config.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.modules.nixos.graphics = { config, ... }:
  {
    config = {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
