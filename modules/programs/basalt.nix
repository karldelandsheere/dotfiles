###############################################################################
#
# Basalt is a tty editor for Obsidian vaults.
#
# It is still in early beta stage though.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.basalt = { config, osConfig, lib, pkgs, ... }:
  {
    config = {
      home = {
        packages = [ pkgs.basalt ];

        persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
          directories = [ ".config/obsidian" ];
        };
      };
    };
  };
}
