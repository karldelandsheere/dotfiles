# Yazi, CLI file explorer
# -----------------------
{ config, pkgs, ... }:
{
  config = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
    };

  
    home = {
      # file.".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/yazi/config";

      packages = with pkgs; [
        ueberzugpp
      ];
    };
  };
}
