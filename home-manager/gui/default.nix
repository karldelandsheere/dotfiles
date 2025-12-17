###############################################################################
# 
# Simple yet effective GUI based on Niri and Noctalia, and all the GUI apps.
#
############################################################################### 

{ config, osConfig, inputs, pkgs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri         # Scrollable tiling compositor
    inputs.noctalia.homeModules.default  # Quickshell integration
    ./programs                           # All the gui programs
  ];

  config = {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ]; # For niri unstable

    programs = {
      niri = {
        enable  = true;
        package = pkgs.niri-unstable;    # Until 25.11 is in nixpkgs stable
      };
      noctalia-shell = {
        enable         = true;
        systemd.enable = true;
      };

      # Launches niri at autologin, but only from tty1
      # -l : https://github.com/YaLTeR/niri/issues/1914 (thanks nisby!)
      # @todo make this shell agnostic
      # ------------------------------
      zsh = {
        enable = true;    # Needed otherwise it's not written in .zprofile
        profileExtra = ''
          if [[ "$(tty)" == "/dev/tty1" ]]; then
            niri-session -l
          fi
        '';
      };
    };


    home = {
      # Utils
      # -----
      packages = with pkgs; [
        nemo                 # File explorer
        xwayland-satellite   # rootless Xwayland integration
      ];


      # Session vars
      # ------------
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


      # Look & feel (@todo implement this so the pointer is the same everywhere)
      # -----------
      # pointerCursor = {
      #   name = "xxx";
      #   package = ...;
      #   size = 24;
      #   gtk.enable = true;
      #   x11.enable = true;
      # };


      # Miscellaneous files
      # -------------------
      file = {
        ".face".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/themes/faces/unnamedplayer.jpg";
        "Pictures/Wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/themes/wallpapers";
      };
    };
  };
}
