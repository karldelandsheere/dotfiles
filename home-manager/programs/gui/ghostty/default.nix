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
      file.".config/ghostty".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.dotfiles}/home-manager/programs/gui/ghostty/config";
    };
  };
}
