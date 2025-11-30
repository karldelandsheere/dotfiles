{ config, osConfig, pkgs, ... }:
{
  # @todo Find out why swayidle is not working as a service
  # -------------------------------------------------------
  config = {
    # services.swayidle = {
    #   enable = true;
    #   systemdTarget = "niri-session.target";
    # };

    home = {
      packages = with pkgs; [ swayidle ];
      # file.".config/swayidle".source =
      #   config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/utils/swayidle/config";
    };
  };
}
