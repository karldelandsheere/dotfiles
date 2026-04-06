###############################################################################
#
# VLC
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.vlc = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.vlc ];

        # What data should persist
        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   directories = [
        #   ];
        # };
      };
    };
  };
}
