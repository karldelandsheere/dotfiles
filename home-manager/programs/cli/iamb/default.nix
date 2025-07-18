# Iamb, a TUI client for Matrix
# -----------------------------
{ config, osConfig, pkgs, ... }:
{
  config = {
    home = {
      packages = [ pkgs.iamb ];

      file.".config/iamb".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/iamb/config";
    };
  };
}
