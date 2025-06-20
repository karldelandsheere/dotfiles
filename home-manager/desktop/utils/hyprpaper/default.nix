{ config, ... }:
{
  config = {
    services.hyprpaper.enable = true;

    # @todo Find how to not have to type the whole path
    home.file.".config/hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/hyprpaper/config/hyprpaper.conf";
  };
}
