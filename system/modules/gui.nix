###############################################################################
# 
# Simple yet effective GUI based on Niri and Noctalia.
# GUI related config, including XDG related stuff. Still a lot to do here.
#
# Next steps:
#   - @todo Implement some stuff from this:
#   https://github.com/jervw/snowflake/blob/main/modules/home/system/xdg/default.nix
############################################################################### 

{ config, inputs, pkgs, lib, ... }: let
  cfg = config.nouveauxParadigmes;
in
{
  imports = [
    inputs.niri.nixosModules.niri          # Scrollable tiling compositor
    inputs.noctalia.nixosModules.default   # Quickshell integration
  ];


  # Related options and default values definition
  options.nouveauxParadigmes = {
    gui.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Enable GUI? Defaults to true.";
    };
  };
  

  config = lib.mkIf cfg.gui.enable {
    # nixpkgs.overlays = [ inputs.niri.overlays.niri ]; # For niri unstable

    programs.niri = {
      enable  = true;
      # package = pkgs.niri-unstable;    # For niri unstable

      # settings = {
      #   # General stuff
      #   # -------------
      #   cursor = {
      #     hide-after-inactive-ms = 3000;
      #     hide-when-typing       = true;
      #   };
        
      #   # Allows notification actions and window activation from Noctalia
      #   debug.honor-xdg-activation-with-invalid-serial = true;
        
      #   environment.DISPLAY = ":0";

      #   hotkey-overlay = {
      #     hide-not-bound  = true;
      #     skip-at-startup = true;
      #   };

      #   layer-rules = [
      #     { # Block notifications from screencast
      #       matches = [ { namespace = "^notification$"; } ];
      #       block-out-from = "screencast";
      #     }

      #     { # Place Noctalia's wallpaper within the backdrop
      #       matches = [ { namespace = "^noctalia-wallpaper*"; } ];
      #       place-within-backdrop = true;
      #     }
      #   ];

      #   layout = {
      #     background-color      = "transparent";
      #     center-focused-column = "never";
      #     default-column-width.proportion = 0.5;
      #     focus-ring = {
      #       active.gradient = {
      #         angle       = 210;
      #         from        = "#80c8ff";
      #         relative-to = "workspace-view";
      #         to          = "#223366";
      #       };
      #       inactive.gradient = {
      #         angle       = 45;
      #         from        = "#505050";
      #         relative-to = "workspace-view";
      #         to          = "#808080";
      #       };
      #       width = 1;
      #     };
      #     gaps = 5;
      #     preset-column-widths = [
      #       { proportion = 0.5; }
      #       { proportion = 0.66667; }
      #     ];
      #   };

      #   outputs."eDP-1" = {
      #     scale                 = 1.2;
      #     variable-refresh-rate = "on-demand=true";
      #   };

      #   overview = {
      #     workspace-shadow.enable = false;
      #     zoom                    = 0.5;
      #   };

      #   prefer-no-csd = true;
      #
      #   spawn-at-startup = [ { argv = ["xwayland-satellite"]; } ];
      # };
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

      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    
      sessionVariables = {
        # CLUTTER_BACKEND = "wayland";
        # DISABLE_QT5_COMPAT = "0"; # Should I set this to 1?
        # GDK_BACKEND = "wayland,x11";
        # GDK_SCALE = "1";
        # GTK_USE_PORTAL = "1";
        NIXOS_OZONE_WL = "1";          # Use Ozone Wayland for Electron apps
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
        nemo                           # File explorer
        xwayland-satellite             # rootless Xwayland integration
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
