###############################################################################
#
# Mpv is a tty media player.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.mpv = { config, osConfig, lib, pkgs, ... }:
  {
    config = {
      home = {
        packages = [ pkgs.mpv ];

        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   directories = [ ".config/obsidian" ];
        # };
      };
    };
  };
}
