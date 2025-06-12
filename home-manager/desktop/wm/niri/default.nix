{ config, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri.enable = true;

  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/wm/niri/config.kdl";
  };

  # @todo make this shell agnostic
  programs.zsh.profileExtra = ''
    exec niri
  '';
}
