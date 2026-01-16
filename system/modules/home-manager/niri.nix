###############################################################################
#
# 
# 
###############################################################################

{ config, osConfig, lib, inputs, ... }: let
  cfg = osConfig.nouveauxParadigmes;
in
{
  config = {
    # Config
    # - https://github.com/YaLTeR/niri/wiki/Configuration
    # - https://github.com/sodiboo/niri-flake/blob/main/docs.md
    # ---------------------------------------------------------
    programs.niri.settings = {
      # General stuff
      # -------------
      cursor = { # Auto hide cursor when we don't need it
        hide-after-inactive-ms = 3000;
        hide-when-typing       = true;
      };

      # Allows notification actions and window activation from Noctalia
      debug.honor-xdg-activation-with-invalid-serial = true;

      environment.DISPLAY = ":0"; # @todo Do we really need it in single screen setups?

      hotkey-overlay = {
        hide-not-bound  = true;
        skip-at-startup = true;
      };

      layer-rules = [
        { # Block notifications from screencast
          matches        = [ { namespace = "^notification$"; } ];
          block-out-from = "screencast"; }

        { # Place Noctalia's wallpaper within the backdrop
          matches               = [ { namespace = "^noctalia-wallpaper*"; } ];
          place-within-backdrop = true; }
      ];

      layout = {
        background-color      = "transparent";
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        focus-ring = {
          active.gradient = {
            angle       = 210;
            from        = "#80c8ff";
            relative-to = "workspace-view";
            to          = "#223366";
          };
          inactive.gradient = {
            angle       = 45;
            from        = "#505050";
            relative-to = "workspace-view";
            to          = "#808080";
          };
          width = 1;
        };
        gaps = 5;
        preset-column-widths = [
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
      };

      outputs."eDP-1" = {
        scale                 = 1.2;
        variable-refresh-rate = "on-demand=true";
      };

      overview = {
        workspace-shadow.enable = false;
        zoom                    = 0.5;
      };

      prefer-no-csd = true;

      # Binds
      # -----
      binds = {
        # Control sound levels
        # --------------------
        "XF86AudioLowerVolume" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "volume" "decrease" ];
          allow-when-locked = true; };
        "XF86AudioMute" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "volume" "muteOutput" ];
          allow-when-locked = true; };
        "XF86AudioRaiseVolume" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "volume" "increase" ];
          allow-when-locked = true; };
        "Shift+XF86AudioLowerVolume" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "volume" "decreaseInput" ];
          allow-when-locked = true; };
        "Shift+XF86AudioMute" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "volume" "muteInput" ];
          allow-when-locked = true; };
        "Shift+XF86AudioRaiseVolume" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "volume" "increaseInput" ];
          allow-when-locked = true; };

        # Control monitor brightness
        # --------------------------
        "XF86MonBrightnessDown" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "brightness" "decrease" ];
          allow-when-locked = true; };
        "XF86MonBrightnessUp" = {
          action.spawn      = [ "noctalia-shell" "ipc" "call" "brightness" "increase" ];
          allow-when-locked = true; };
        # XFAudioNext
        # XF86AudioPlay
        # XFAudioPrev
        # XF86TouchpadToggle

        # Screenshot utils
        # ----------------
        "Print".action.spawn      = "screenshot";
        "Alt+Print".action.spawn  = "screenshot-window";
        "Ctrl+Print".action.spawn = "screenshot-screen";

        # Launching different kinds of menus and panels
        # -----------------------------------------------
        "Mod+F10".action.spawn   = [ "noctalia-shell" "ipc" "call" "settings" "toggle" ];
        "Mod+F11".action.spawn   = [ "noctalia-shell" "ipc" "call" "sessionMenu" "toggle" ];
        "Mod+F12".action.spawn   = [ "noctalia-shell" "ipc" "call" "controlCenter" "toggle" ];
        "Mod+Space".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
        "Mod+Tab".action.spawn   = "toggle-overview";

        # Change focus
        # ------------
        "Mod+Down".action.spawn        = "focus-window-or-workspace-down";
        "Mod+Left".action.spawn        = "focus-column-left";
        "Mod+Right".action.spawn       = "focus-column-right";
        "Mod+Up".action.spawn          = "focus-window-or-workspace-up";
        "Mod+Home".action.spawn        = "focus-column-first";
        "Mod+End".action.spawn         = "focus-column-last";
        # "Mod+Shift+Down".action.spawn  = "focus-monitor-down";
        # "Mod+Shift+Left".action.spawn  = "focus-monitor-left";
        # "Mod+Shift+Right".action.spawn = "focus-monitor-right";
        # "Mod+Shift+Up".action.spawn    = "focus-monitor-up";

        # Move focused column/window/workspace
        # ------------------------------------
        "Mod+Ctrl+Down".action.spawn        = "move-window-down";
        "Mod+Ctrl+Left".action.spawn        = "move-column-left";
        "Mod+Ctrl+Right".action.spawn       = "move-column-right";
        "Mod+Ctrl+Up".action.spawn          = "move-window-up";
        "Mod+Ctrl+Home".action.spawn        = "move-column-to-first";
        "Mod+Ctrl+End".action.spawn         = "move-column-to-last";
        # "Mod+Shift+Ctrl+Down".action.spawn  = "move-window-to-monitor-down";
        # "Mod+Shift+Ctrl+Left".action.spawn  = "move-window-to-monitor-left";
        # "Mod+Shift+Ctrl+Right".action.spawn = "move-window-to-monitor-right";
        # "Mod+Shift+Ctrl+Up".action.spawn    = "move-window-to-monitor-up";
        "Mod+C".action.spawn                = "center-column";
        "Mod+Shift+Comma".action.spawn      = "consume-window-into-column";
        "Mod+Shift+Semicolon".action.spawn  = "expel-window-from-column";

        # Toggle floating and move focus between floating and tiling
        # ----------------------------------------------------------
        "Mod+V".action.spawn       = "toggle-window-floating";
        "Mod+Shift+V".action.spawn = "switch-focus-between-floating-and-tiling";

        # Control the width/height of the focused column/window
        # -----------------------------------------------------
        "Mod+Equal".action.spawn       = [ "set-column-width" "+10%" ];
        "Mod+F".action.spawn           = "maximize-column";
        "Mod+Minus".action.spawn       = [ "set-column-width" "-10%" ];
        "Mod+R".action.spawn           = "switch-preset-column-width";
        "Mod+Shift+Equal".action.spawn = [ "set-window-height" "+10%" ];
        "Mod+Shift+F".action.spawn     = "fullscreen-window";
        "Mod+Shift+Minus".action.spawn = [ "set-window-height" "-10%" ];

        # Toggle window opacity
        # ---------------------
        "Mod+O".action.spawn = "toggle-window-rule-opacity";

        # Toggle keyboard shortcuts inhibit (such as in remote-desktop and such)
        # ---------------------------------
        "Mod+Alt+Escape" = {
          action.spawn     = "toggle-keyboard-shortcuts-inhibit";
          allow-inhibiting = false; };

        # Close stuff
        # -----------
        "Mod+Q".action.spawn = "close-window";
      };

      # Inputs
      # ------
      input = {
        gestures.hot-corners.enable = false;

        touchpad = {
          accel-profile = "adaptive";
          accel-speed   = 0.2;
          # disabled-on-external-mouse = true;
          dwt = true;
        };

        warp-mouse-to-focus = {
          enable = true;
          mode = "center-xy"; };
      };
    };
  };
}
