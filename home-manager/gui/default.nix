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
        package = pkgs.niri-unstable;                # Until 25.11 is in nixpkgs stable
        # settings.environment."NIXOS_OZONE_WL" = "1"; # Use Ozone Wayland forx Electron apps
      };
      noctalia-shell = {
        enable         = true;
        systemd.enable = true;
      };

      # Launches niri at autologin, but only from tty1
      # @todo make this shell agnostic
      # Well... it crashes so yeah, no
      # ------------------------------
      # zsh = {
      #   enable = true;    # Needed otherwise it's not written in .zprofile
      #   profileExtra = ''
      #     if [[ "$(tty)" == "/dev/tty1" ]]; then
      #       niri-session
      #     fi
      #   '';
      # };
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
        # GTK_USE_PORTAL = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
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
      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
