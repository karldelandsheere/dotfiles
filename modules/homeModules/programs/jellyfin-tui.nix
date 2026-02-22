###############################################################################
#
# Jellyfin-tui is a tty client for the Jellyfin media server.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.jellyfin-tui = { config, osConfig, lib, pkgs, ... }:
  {
    config = {
      home = {
        packages = [ pkgs.jellyfin-tui ];

        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   # files = [ ".config/Bitwarden CLI/data.json" ];
        #   directories = lib.mkIf withDesktop [ ".config/Bitwarden" ];
        # };
      };
    };
  };
}
