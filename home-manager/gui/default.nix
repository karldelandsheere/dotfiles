{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    
    # ./niri
    # ./noctalia
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
          exec niri --session
        fi
      '';
    };

    
    home = {
      packages = with pkgs; [
        # nemo
        # qt5.qtwayland
        # qt6.qtwayland
        xwayland-satellite
      ];


      # Session vars
      # ------------
      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };



      # Config files/folders
      # --------------------
      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };


    # Config files
    # ------------
    # xdg.configFile = {
    #   niri = {
    #     source = config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/config/everywhere/niri";
    #     recursive = true;
    #   };

    #   noctalia = {
    #     source = config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/config/everywhere/noctalia";
    #     recursive = true;
    #   };
    # };
  };
}
