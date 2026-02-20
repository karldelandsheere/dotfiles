###############################################################################
#
# Obsidian is a (not foss) Markdown note taking app. 
#
# This module enables clients: basalt (tty) and obsidian.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.obsidian = { config, osConfig, lib, pkgs, ... }: let
    withDesktop = osConfig.features.desktop.enable;
    withImpermanence = osConfig.features.impermanence.enable;
  in
  {
    config = {
      home.packages = [ pkgs.basalt ] # Still in early beta stage
        ++ lib.lists.optionals withDesktop [ pkgs.obsidian ];

      # What data should persist
      home.persistence."/persist" = lib.mkIf ( withImpermanence && withDesktop ) {
        directories = [ ".config/obsidian" ];
      };
    };
  };
}
