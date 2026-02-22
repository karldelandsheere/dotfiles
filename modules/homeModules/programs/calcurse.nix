###############################################################################
#
# Calcurse is a tty editor calendar.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.calcurse = { config, osConfig, lib, pkgs, ... }:
  {
    config = {
      home = {
        packages = [ pkgs.calcurse ];

        persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
          directories = [ ".local/share/calcurse" ];
        };
      };
    };
  };
}
