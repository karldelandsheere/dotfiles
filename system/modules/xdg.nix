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
          xdg-desktop-portal
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


    environment = {
      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";          # Niri flake setting for electron apps
        # GTK_IM_MODULE  = "simple";     # Fixing the tilde character in Ghostty
      };
    };
  };    
}
