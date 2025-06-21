{ config, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    ./utils.nix
  ];


  programs.niri.enable = true;

  # @todo Could we get away with the full absolute path?
  home.file.".config/niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/wm/niri/config.kdl";


  # @todo make this shell agnostic
  programs.zsh.profileExtra = ''
    exec niri --session
  '';
}
