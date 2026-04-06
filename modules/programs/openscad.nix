###############################################################################
#
# Openscad, code based 2D/3D CAD.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.openscad = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.openscad ];

        # What data should persist
        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   directories = [
        #   ];
        # };
      };
    };
  };
}
