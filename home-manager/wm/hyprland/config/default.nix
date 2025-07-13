{ config, ... }: let
  hyprConfigDir = "/etc/nixos/home-manager/wm/hyprland/config";
in
{
  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${hyprConfigDir}/hypr";
    # ".config/uwsm/env-hyprland".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/uwsm-env-hyprland";
  };
}
