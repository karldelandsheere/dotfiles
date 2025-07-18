# Gurk, a TUI client for Signal
# -----------------------------
{ config, osConfig, pkgs, ... }:
{
  config = {
    home = {
      packages = [ pkgs.gurk-rs ];

      file.".config/gurk".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/gurk/config";
    };
  };
}
