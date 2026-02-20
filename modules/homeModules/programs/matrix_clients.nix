###############################################################################
#
# Matrix/Synapse is a privacy focused messaging platform and protocol.
#
# This module enables clients: iamb (tty) and element-desktop.
#
# @todo Move the profiles out of this
#       in order to make this module more reusable.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.matrix_clients = { config, osConfig, lib, ... }: let
    withDesktop = osConfig.features.desktop.enable;
    withImpermanence = osConfig.features.impermanence.enable;
  in
  {
    config = {
      programs = {
        iamb = {
          enable = true;
          settings = {
            default_profile = "dimeritium"; #config.home.username;
            layout = {
              style = "config";
              tabs = [
                { window = "iamb://dms"; }
                { window = "iamb://rooms"; }
              ];
            };
            profiles = { # @todo Move this to secrets
              "dimeritium" = {
                url = "https://matrix.dimeritium.com";
                user_id = "@karldelandsheere:matrix.dimeritium.com";
              };
            };
            settings = {
              image_preview = {
                protocol.type = "sixel";
                size = {
                  height = 20;
                  width = 66;
                };
              };
              log_level = "warn";
              notifications.enabled = true;
              sort = {
                rooms = [ "unread" "favorite" "name" "lowpriority" ];
                members = [ "id" "power" ];
              };
              user_gutter_width = 30;
              username_display = "username";
            };
          };
        };

        # element-desktop = lib.mkIf withDesktop {
        #   enable = false; # For now
        #   profiles = {};
        #   settings = {};
        # };
      };

      # What data should persist
      home.persistence."/persist" = lib.mkIf withImpermanence {
        directories =
          [ ".local/share/iamb" ];
          # ++ lib.lists.optionals withDesktop [ ".config/Element" ];
      };
    };
  };
}
