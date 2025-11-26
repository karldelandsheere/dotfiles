# Ghostty terminal emulator
# -------------------------
{ config, osConfig, ... }:
{
  config = {
    programs.obsidian = {
      enable = true;
    };

    # home = {
    #   file.".config/ghostty".source =
    #     config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/gui/ghostty/config";
    # };
  };
}
