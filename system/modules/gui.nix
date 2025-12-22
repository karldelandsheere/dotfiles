###############################################################################
# 
# Simple yet effective GUI based on Niri and Noctalia, and all the GUI apps.
#
############################################################################### 

{ config, inputs, pkgs, lib, ... }: let
  cfg = config.nouveauxParadigmes;
in
{
  imports = [
    inputs.niri.nixosModules.niri          # Scrollable tiling compositor
    inputs.noctalia.nixosModules.default   # Quickshell integration
  ];


  config = lib.mkIf cfg.gui.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ]; # For niri unstable

    programs.niri = {
      enable  = true;
      package = pkgs.niri-unstable;    # Until 25.11 is in nixpkgs stable
    };

    # Use Noctalia as a systemd service
    services.noctalia-shell.enable = true;


    # Utils for the gui
    environment = {
      # Launches niri at autologin, but only from tty1
      # -l : https://github.com/YaLTeR/niri/issues/1914 (thanks nisby!)
      loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          niri-session -l
        fi
      '';
    
      sessionVariables = {
        # CLUTTER_BACKEND = "wayland";
        # DISABLE_QT5_COMPAT = "0"; # Should I set this to 1?
        # GDK_BACKEND = "wayland,x11";
        # GDK_SCALE = "1";
        # GTK_USE_PORTAL = "1";
        # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        # QT_QPA_PLATFORM = "wayland-egl";
        # QT_QPA_PLATFORMTHEME = "qt6ct";
        # QT_SCALE_FACTOR = "1";
        # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # SDL_VIDEO_DRIVER = "wayland";
        # WLR_BACKEND = "vulkan";
        # WLR_RENDERER = "vulkan";
        # WLR_NO_HARDWARE_CURSORS = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
        # XDG_SESSION_TYPE = "wayland";
      };
      
      systemPackages = with pkgs; [
        nemo                 # File explorer
        xwayland-satellite   # rootless Xwayland integration
      ];
    };



    # home = {
      # Utils
      # -----


      # Session vars
      # ------------


      # Look & feel (@todo implement this so the pointer is the same everywhere)
      # -----------
      # pointerCursor = {
      #   name = "xxx";
      #   package = ...;
      #   size = 24;
      #   gtk.enable = true;
      #   x11.enable = true;
      # };
    # };
  };
}
