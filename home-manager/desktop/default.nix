{ config, pkgs, ... }:
{
  imports = [
    ./config
    ./wm/niri
  ];

  config = {
    # Used to be in my Hyprland config but it's not really tied to it, is it?
    # @TODO has it that I'll move that under something like ./utils or ./programs
    # ---------------------------------------------------------------------------
    xdg.portal = {
      enable = true;
      config.common.default = [ "gtk" ];
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };


    programs = {
      fuzzel.enable = true;

      wlogout = {
        enable = true;
      };

      waybar = {
        enable = true;
        systemd.enable = true;
      };
    };


    # programs.swaylock = {
    #   enable = true;
    # };
    
    services = {
      mako.enable = true;
      
      swayidle = {
        enable = true;
        systemdTarget = "niri-session.target";
        timeouts = [
          { timeout = 5; command = "swaylock"; }
          { timeout = 900; command = "systemctl suspend"; }
        ];
        events = [
          { event = "before-sleep"; command = "swaylock"; }
          { event = "lock"; command = "swaylock"; }
        ];
      };
    };

    # home.packages = with pkgs; [
    #   swaylock-effects
    # ];

    home.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      DISABLE_QT5_COMPAT = "0"; # should I set this to 1?
      GDK_BACKEND = "wayland";
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
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XCURSOR_SIZE = "24";
    };

  };
}
