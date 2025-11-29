{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    ./niri
    ./noctalia
  ];

  config = {
    home = {
      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
