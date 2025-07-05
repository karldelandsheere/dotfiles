{ config, osConfig, ... }:
{
  config = {
    services.mako.enable = true;

    home.file.".config/mako".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.dotfiles}/home-manager/utils/mako/config";
  };
}
