{ config, ... }:
{
  config = {
    # programs.swaylock.enable = true;

    # @todo Find how to not have to type the whole path
    home.file.".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/swaylock/config";
  };
}
