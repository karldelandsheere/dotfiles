{ config, pkgs, ... }:
{
  # Common configuration for a window manager, given that
  # it is based on Wayland and uses a GTK theme
  # -------------------------------------------
  config = {
    # GTK
    # ---
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };


    # Qt
    # --
    qt.platformTheme = "gtk";


    # Variables for all that
    # ----------------------
    home.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      DISABLE_QT5_COMPAT = "0"; # should I set this to 1?
      GDK_BACKEND = "wayland,x11";
      GDK_SCALE = "1";
      GTK_USE_PORTAL = "1";
      NIXOS_OZONE_WL = "1"; # use Ozone Wayland for Electron apps
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland-egl";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEO_DRIVER = "wayland";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      XCURSOR_SIZE = "24";
    };
  };
}
