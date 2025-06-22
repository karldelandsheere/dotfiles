{ config, pkgs, ... }:
{
  # @todo Find out why swayidle is not working
  # ------------------------------------------
  config = {
    # services.swayidle = {
    #   enable = true;
    #   systemdTarget = "niri-session.target";
    # };

# swayidle = {
#       path = with pkgs; [ swaylock-effects niri ];
#       description = "Idle Service";
#       after = [ "niri.service" ];
#       wantedBy = [ "graphical-session.target" ];
#       serviceConfig = {
#         ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 301 'niri msg action power-off-monitors' timeout 300 'swaylock -f' before-sleep 'swaylock -f'";
#         Restart = "on-failure";
#       };
#     };

    # @todo Find how to not have to type the whole path
    home.file.".config/swayidle".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/utils/swayidle/config";
  };
}
