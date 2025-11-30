{ config, osConfig, inputs, pkgs, ... }: let
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = {
    programs = {
      noctalia-shell = {
        enable = true;
        systemd.enable = true;
      };

      # Utils
      # -----
    };
    

    home = {
      file.".config/noctalia".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/gui/noctalia/config";

      file."Pictures/Wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/themes/wallpapers";
    };
  };
}
