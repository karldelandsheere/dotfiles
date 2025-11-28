# Obsidian
# --------
{ config, osConfig, ... }:
{
  config = {
    programs.obsidian = {
      enable = true;
      # vaults.Braindump = {
      #   enable = true;
      #   target = "Data/Notes/Braindump";
      # };
    };

    # home = {
    #   file.".config/obsidian".source =
    #     config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/gui/obsidian/config";
    # };
  };
}
