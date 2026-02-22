###############################################################################
#
# Signal is a privacy focused messaging platform and protocol.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.signal-desktop = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.signal-desktop ];

        persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
          directories = [ ".config/Signal" ];
        };
      };
    };
  };
}
