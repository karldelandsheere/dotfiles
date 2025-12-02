# Signal
# ------
{ config, osConfig, pkgs, ... }:
{
  config = {
    home = {
      packages = with pkgs; [ signal-desktop ];
      file.".config/Signal/Preferences".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/gui/signal/config/Preferences";
    };
  };
}
