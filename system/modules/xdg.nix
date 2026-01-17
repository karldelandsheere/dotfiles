###############################################################################
# 
# XDG related config. Still a lot to do here.
#
# Next steps:
#   - @todo Implement some stuff from this:
#   https://github.com/jervw/snowflake/blob/main/modules/home/system/xdg/default.nix
############################################################################### 

{ config, inputs, pkgs, lib, ... }: let
  cfg = config.nouveauxParadigmes;
in
{
  config = lib.mkIf cfg.gui.enable {
    # Utils for the gui
    environment = {
      # Launches niri at autologin, but only from tty1
      # -l : https://github.com/YaLTeR/niri/issues/1914 (thanks nisby!)
      # @todo move this in niri's config
      loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          niri-session -l
        fi
      '';

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
        enable           = true;
        wlr.enable       = true;
        xdgOpenUsePortal = true;

        config = {
          common = {
            default = ["gnome"];
            "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
            "org.freedesktop.impl.portal.OpenURI"     = ["gtk"];
          };

          niri = {
            default = ["gnome"];
            "org.freedesktop.impl.portal.FileChooser"   = ["gtk"];
            "org.freedesktop.impl.portal.OpenURI"       = ["gtk"];
            "org.freedesktop.impl.portal.RemoteDesktop" = ["gnome"];
            "org.freedesktop.impl.portal.ScreenCast"    = ["gnome"];
            "org.freedesktop.impl.portal.Screenshot"    = ["gnome"];
            "org.freedesktop.impl.portal.Secret"        = ["gnome-keyring"];
          };
        };

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
      };

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
}
