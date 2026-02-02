###############################################################################
#
# Hardware accelerated graphics generic config.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.features_graphics = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      hardware.graphics = {
        enable = true;
        enable32Bit = true; # Should I move that one to host?
      };
    };
  };
}
