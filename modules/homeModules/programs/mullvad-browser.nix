###############################################################################
#
# Mullvad Browser is a highly privacy focused browser. 
#
# It's a Firefox fork, developped by Mullvad and the Tor Project.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.mullvad-browser = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.mullvad-browser ];

        sessionVariable.BROWSER =
          "${pkgs.mullvad-browser}/bin/mullvad-browser";

        # What data should persist
        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   directories = [ ".config/obsidian" ];
        # };
      };
    };
  };
}
