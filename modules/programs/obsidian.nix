###############################################################################
#
# Obsidian is a (not foss) Markdown note taking app. 
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.obsidian = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.obsidian ];

        # What data should persist
        persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
          directories = [ ".config/obsidian" ];
        };
      };
    };
  };
}
