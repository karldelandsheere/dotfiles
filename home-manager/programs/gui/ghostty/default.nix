# Ghostty terminal emulator
# -------------------------
{ config, osConfig, ... }:
{
  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
    };

    home = {
      # file.".config/ghostty".source =
        # config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/gui/ghostty/config";
    };
  };
}
