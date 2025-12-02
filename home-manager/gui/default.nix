{ config, osConfig, pkgs, ... }: let
in
{
  imports = [
    ./niri
    ./noctalia
    ./programs
  ];

  config = {
    home = {
      packages = with pkgs; [
        # nemo
        # qt5.qtwayland
        # qt6.qtwayland
        xwayland-satellite
      ];


      xdg.configFile.niri = {
        source = config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/config/everywhere/niri";
        recursive = true;
      };



      # Config files/folders
      # --------------------
      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
