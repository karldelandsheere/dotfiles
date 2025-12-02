# Helix
# -----
{ config, osConfig, pkgs, ... }:
{
  config = {
    home = {
      packages = [ pkgs.fastfetch ];
      # file.".config/fastfetch".source =
        # config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/fastfetch/config";
    };
  };
}
