###############################################################################
#
# BambuStudio, the slicer for Bambu 3d printers.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.bambu-studio = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.bambu-studio ];

        # What data should persist
        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   directories = [
        #     ".config/PrusaSlicer"
        #     ".local/share/prusa-slicer"
        #   ];
        # };
      };
    };
  };
}
