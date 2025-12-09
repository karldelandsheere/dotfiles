###############################################################################
# 
# XDG related stuff (obviously). There's a lot to do here.
#
###############################################################################

{ config, lib, pkgs, ... }:
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    gui.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Enable GUI? Defaults to true.";
    };
  };

  
  config = {
    xdg = {
      # Portal, for screenshots, screencast, ...
      # @todo Make it work for niri but with wlr
      #   like sakithb did (https://github.com/YaLTeR/niri/issues/544#issuecomment-2906930349)
      # ------------------
      portal = {
        enable = true;
        wlr.enable = true;
        xdgOpenUsePortal = true;
        config.common = {
          default = [ "gnome" "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };

      # mimeApps.defaultApplications = {
      #   "application/xhtml+xml" = "firefox.desktop";
      #   "text/html" = "firefox.desktop";
      #   "text/xml" = "firefox.desktop";
      #   "x-scheme-handler/http" = "firefox.desktop";
      #   "x-scheme-handler/https" = "firefox.desktop";
      # };
    };

    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications" ];
  };    
}
