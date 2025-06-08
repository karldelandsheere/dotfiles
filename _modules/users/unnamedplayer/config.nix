{ config, ... }: let
  configDir = "/etc/nixos/modules/config";
in
{
  home.file = {
    ".config/fuzzel/fuzzel.ini".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/fuzzel.ini";
    ".config/helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/helix-config.toml";
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr";
    ".config/uwsm".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/uwsm";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/waybar";
  };
}
