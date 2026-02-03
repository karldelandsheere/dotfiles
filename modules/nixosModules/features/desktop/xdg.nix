###############################################################################
#
# XDG related config.
#
# For host|user specific options, go to host|user's config.
#
# Next steps:
#   - @todo Implement some stuff from this:
#   https://github.com/jervw/snowflake/blob/main/modules/home/system/xdg/default.nix
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.desktop = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      environment = {
        pathsToLink = [
          "/share/xdg-desktop-portal"
          "/share/applications"
        ];
      };

      xdg = {
        # Enable portal for spawning extra windows,
        # screenshots, screencast, file picker, ...
        # @todo but no pressure, convert to wlr like
        #   https://github.com/YaLTeR/niri/issues/544#issuecomment-2906930349
        portal = {
          enable = true;
          wlr.enable = true;
          xdgOpenUsePortal = true;

          config = {
            common = {
              default = ["gnome"];
              # "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
              "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
              "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
              "org.freedesktop.impl.portal.RemoteDesktop" = ["gnome"];
              "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
              "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
              "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
            };
          };

          extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
            xdg-desktop-portal-termfilechooser
          ];
        };

        # configFile."xdg-desktop-portal-termfilechooser/config" = {
        #   # enable = false;
        #   text = ''
        #     [filechooser]
        #     cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        #     default_dir=$HOME
        #     env=TERMCMD='ghostty --title="terminal-filechooser" -e'
        #     open_mode=suggested
        #     save_mode=last
        #   '';
        # };

        # @todo What was this about again?
        # mimeApps.defaultApplications = {
        #   "application/xhtml+xml" = "firefox.desktop";
        #   "text/html" = "firefox.desktop";
        #   "text/xml" = "firefox.desktop";
        #   "x-scheme-handler/http" = "firefox.desktop";
        #   "x-scheme-handler/https" = "firefox.desktop";
        # };
      };
    };
  };
}
