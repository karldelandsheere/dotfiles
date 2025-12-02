{ config, osConfig, ... }:
{
  config = {
    programs.fuzzel.enable = true;

    home.file.".config/fuzzel".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/utils/fuzzel/config";
  };
}
