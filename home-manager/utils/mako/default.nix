{ config, ... }:
{
  config = {
    services.mako.enable = true;

    # @todo Find how to not have to type the whole path
    home.file.".config/mako".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/utils/mako/config";
  };
}
