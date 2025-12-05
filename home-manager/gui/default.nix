{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    
    ./programs
  ];

  config = {

    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    programs = {
      niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
      noctalia-shell = {
        enable = true;
        systemd.enable = true;
      };

      # Launches niri at autologin, but only from tty1
      # @todo make this shell agnostic
      # ------------------------------
      zsh.profileExtra = ''
        if [[ "$(tty)" == "/dev/tty1" ]]; then
          exec niri-session
        fi
      '';
    };


    home = {
      # Utils
      # -----
      packages = with pkgs; [
        nemo
        xwayland-satellite
      ];


      # Session vars
      # ------------
      sessionVariables = {
        # CLUTTER_BACKEND = "wayland";
        # DISABLE_QT5_COMPAT = "0"; # Should I set this to 1?
        # GTK_USE_PORTAL = "1";
        # NIXOS_OZONE_WL = "1"; # Use Ozone Wayland for Electron apps
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };


      # Miscellaneous files
      # -------------------
      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
