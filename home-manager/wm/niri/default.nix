{ config, osConfig, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  config = {
    programs.niri.enable = true;


    home = {
      file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/wm/niri/config.kdl";

      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };
    };


    # loginShellInit = ''

    # '';



    # @todo make this shell agnostic
    programs.zsh.profileExtra = ''
      exec niri --session
    '';
  };
}
