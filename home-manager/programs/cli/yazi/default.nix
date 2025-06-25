{ config, pkgs, ... }:
{
  config = {
    # Yazi
    # -----
    programs.yazi = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
    };

    home.packages = with pkgs; [
      ueberzugpp
    ];

    home = {
      file.".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/yazi/config";
    };
  };
}
