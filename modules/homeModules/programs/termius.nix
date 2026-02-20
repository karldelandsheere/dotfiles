###############################################################################
#
# Termius is a (not foss) cross-platform SSH client. 
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.termius = { config, osConfig, lib, pkgs, ... }: let
    withDesktop = osConfig.features.desktop.enable;
    withImpermanence = osConfig.features.impermanence.enable;
  in
  {
    config = lib.mkIf withDesktop {
      home.packages = [ pkgs.termius ];

      # What data should persist
      home.persistence."/persist" = lib.mkIf withImpermanence {
        directories = [ ".config/Termius" ];
      };
    };
  };
}
