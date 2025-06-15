{ config, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri

    # utils
    ../../utils/fuzzel
    ../../utils/swayidle
    ../../utils/swaylock
    ../../utils/waybar
  ];

  programs.niri.enable = true;

  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/wm/niri/config.kdl";
  };

  # services.swayidle.systemdTarget = "niri-session.target";

  services.blueman-applet.enable = true;


  # @todo make this shell agnostic
  programs.zsh.profileExtra = ''
    exec niri
  '';
}
