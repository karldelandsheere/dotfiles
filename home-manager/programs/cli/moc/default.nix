{ config, pkgs, ... }:
{
  config = {
    # Moc: terminal audio player
    # --------------------------
    home = {
      packages = with pkgs; [ moc ];
      file."./config/moc/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/moc/config/config";
      file."./config/moc/themes".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/moc/themes";
    };
  };
}
