{ config, ... }:
{
  config = {
    services.hypridle.enable = true;

    # @todo Find how to not have to type the whole path
    home.file.".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/utils/hypridle/config/hypridle.conf";
  };
}
