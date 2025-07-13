{ config, osConfig, ... }:
{
  config = {
    services.mako.enable = true;

    home.file.".config/mako".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/utils/mako/config";
  };
}
