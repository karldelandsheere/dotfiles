# Calcurse, a TUI calDav with todo
# --------------------------------
{ config, osConfig, pkgs, ... }:
{
  config = {
    home = {
      packages = [ pkgs.calcurse ];
      # file.".config/calcurse".source =
        # config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/calcurse/config";
    };
  };
}
