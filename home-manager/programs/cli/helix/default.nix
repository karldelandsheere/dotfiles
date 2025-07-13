# Helix
# -----
{ config, osConfig, ... }:
{
  config = {
    programs.helix = {
      enable = true;
      defaultEditor = true;
    };

    home = {
      sessionVariables.EDITOR = "hx";
      file.".config/helix".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/helix/config";
    };
  };
}
