{ config, pkgs, ... }:
{
  # @todo Find out why swayidle is not working as a service
  # -------------------------------------------------------
  config = {
    # services.swayidle = {
    #   enable = true;
    #   systemdTarget = "niri-session.target";
    # };
    home.packages = with pkgs; [ swayidle ];

    # @todo Find how to not have to type the whole path
    home.file.".config/swayidle".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/utils/swayidle/config";
  };
}
