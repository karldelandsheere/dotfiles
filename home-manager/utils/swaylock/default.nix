{ config, osConfig, ... }:
{
  config = {
    # programs.swaylock.enable = true;

    home.file.".config/swaylock".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/utils/swaylock/config";
  };
}
