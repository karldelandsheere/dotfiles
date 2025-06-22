{ config, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];


  programs.niri.enable = true;

  # @todo Could we get away with the full absolute path?
  home.file.".config/niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/wm/niri/config.kdl";


  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
  };


  # @todo make this shell agnostic
  programs.zsh.profileExtra = ''
    exec niri --session
  '';
}
