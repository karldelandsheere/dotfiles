{ config, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri

    # utils
    ../../utils/fuzzel
    ../../utils/hyprpaper
    ../../utils/swayidle
    ../../utils/swaylock
    ../../utils/waybar
    ../../utils/wlogout
  ];

  programs.niri.enable = true;

  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/wm/niri/config.kdl";
  };

  # services.swayidle.systemdTarget = "niri-session.target";

  # @todo make this shell agnostic
  programs.zsh.profileExtra = ''
    exec niri
  '';
}
