{ config, osConfig, pkgs, ... }: let
in
{
  imports = [
    ./niri
    ./noctalia
    ../programs/gui
  ];

  config = {
    home = {
      packages = with pkgs; [
        # nemo
        # qt5.qtwayland
        # qt6.qtwayland
        xwayland-satellite
      ];


      # Config files/folders
      # --------------------
      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
