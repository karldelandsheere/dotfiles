{ config, ... }:
{
  config = {
    programs.fuzzel.enable = true;

    # @todo Find how to not have to type the whole path
    home.file.".config/fuzzel".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/fuzzel";
  };
}
