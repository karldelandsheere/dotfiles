###############################################################################
#
# Rustdesk is a foss Remote Desktop alternative to AnyDesk or TeamViewer.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.rustdesk = { config, osConfig, lib, pkgs, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      home = {
        packages = [ pkgs.rustdesk-flutter ];

        # What data should persist
        # persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        #   directories = [
        #   ];
        # };
      };
    };
  };
}
