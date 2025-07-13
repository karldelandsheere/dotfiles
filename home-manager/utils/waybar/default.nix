{ config, osConfig, ... }:
{
  config = {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "niri-session.target";
      };
    };

    home.file.".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/utils/waybar/config";
  };
}
