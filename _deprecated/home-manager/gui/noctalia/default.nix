{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
    };
    

    home = {
      # Utils
      # -----
      packages = with pkgs; [
        # Temporary, until Noctalia sorts the wallpaper management
        swaybg
      ];


      # Config files/folders
      # --------------------
      file.".config/noctalia".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/gui/noctalia/config";

      # When Noctalia manage the wallpaper like I want and do in Niri, I'll get back to this
      # file."Pictures/Wallpapers".source =
      #   config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
