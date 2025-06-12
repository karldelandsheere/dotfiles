{ config, ... }: let
  configDir = "/etc/nixos/home-manager/desktop/config";
in
{
  home.file = {
    ".config/fuzzel/fuzzel.ini".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/fuzzel.ini";
    ".config/helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/helix-config.toml";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/swaylock";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/waybar";
  };
}
