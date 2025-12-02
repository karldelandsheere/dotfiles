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
  };
}
