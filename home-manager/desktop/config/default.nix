{ config, ... }: let
  configDir = "/etc/nixos/home-manager/desktop/config";
in
{
  home.file = {
    # ".config/fuzzel".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/fuzzel";
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/helix";
    # ".config/swayidle".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/swayidle";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/swaylock";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/waybar";
  };
}
