###############################################################################
#
# PrusaSlicer, the slicer for Prusa 3d printers (but not only).
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.prusa-slicer = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.prusa-slicer ];

        # What data should persist
        persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
          directories = [
            ".config/PrusaSlicer"
            ".local/share/prusa-slicer"
          ];
        };
      };
    };
  };
}
