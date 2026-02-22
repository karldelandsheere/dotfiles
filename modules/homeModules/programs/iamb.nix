###############################################################################
#
# iamb is a tty Matrix client.
#
# Matrix/Synapse is a privacy focused messaging platform and protocol.
#
# @todo Move the profiles out of this
#       in order to make this module more reusable.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.iamb = { config, osConfig, lib, ... }:
  let
    matrix = { # @todo Move this to secrets
      default_profile = config.home.username;
      profiles = {
        config.home.username = {
          url = "https://matrix.org";
          user_id = "@karldelandsheere:matrix.org";
        };
      };
    };
  in
  {
    config = {
      programs = {
        iamb = {
          enable = true;
          settings = {
            default_profile = matrix.default_profile;
            layout = {
              style = "config";
              tabs = [
                { window = "iamb://dms"; }
                { window = "iamb://rooms"; }
              ];
            };
            profiles = matrix.profiles;
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
      };

      # What data should persist
      home.persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        directories = [ ".local/share/iamb" ];
      };
    };
  };
}
