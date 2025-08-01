# Moc: terminal audio player
# --------------------------
{ config, pkgs, ... }:
{
  config = {
    home = {
      packages = with pkgs; [ moc ];
      file.".moc/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/moc/config/config";
      file.".moc/themes".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/moc/themes";
    };
  };
}
