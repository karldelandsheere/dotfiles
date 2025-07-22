# Aerc, a TUI email client
# ------------------------
{ config, osConfig, pkgs, ... }:
{
  config = {
    programs.aerc = {
      enable = true;
      extraConfig = {
        general = {
          # pgp-provider = "auto";
          unsafe-accounts-conf = true;
        };

        ui = {
          mouse-enabled = true;
          sidebar-width = 30;
          dirlist-tree = true;
          dirlist-collapse = 1;
          threading-enabled = true;
          styleset-name = "catppuccin-mocha";
        };

        compose = {
          file-picker-cmd = "yazi";
        };

        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          ".headers" = "colorize";
        };

        # hooks = {
          #mail-received=notify-send "[$AERC_ACCOUNT/$AERC_FOLDER] New mail from $AERC_FROM_NAME" "$AERC_SUBJECT"
          # 
        # };
      };
    };

    # home.file.".config/aerc".source =
    #   config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/aerc/config";
  };
}
