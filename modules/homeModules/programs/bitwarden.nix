###############################################################################
#
# Bitwarden, a foss password & secrets vault.
#
# This module enables clients: bitwarden-cli (tty) and bitwarden-desktop.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.bitwarden = { config, osConfig, lib, pkgs, ... }: let
    withDesktop = osConfig.features.desktop.enable;
    withImpermanence = osConfig.features.impermanence.enable;
  in
  {
    config = {
      home = {
        packages = ( with pkgs; [ bitwarden-cli ]
          ++ lib.lists.optionals withDesktop [ bitwarden-desktop ]
        );

        persistence."/persist" = lib.mkIf withImpermanence {
          # files = [ ".config/Bitwarden CLI/data.json" ];
          directories = lib.mkIf withDesktop [ ".config/Bitwarden" ];
        };
      };
    };
  };
}
