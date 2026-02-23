###############################################################################
#
# Termius is a (not foss) cross-platform SSH client. 
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.termius = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home.packages = [ pkgs.termius ];

      # Ressources to persist
      home.persistence."/persist" =
        lib.mkIf osConfig.features.impermanence.enable {
          directories = [ ".config/Termius" ];
        };
    };
  };
}
