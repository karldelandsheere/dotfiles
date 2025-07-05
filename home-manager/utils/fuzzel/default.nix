{ config, osConfig, ... }:
{
  config = {
    programs.fuzzel.enable = true;

    home.file.".config/fuzzel".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.dotfiles}/home-manager/utils/fuzzel/config";
  };
}
