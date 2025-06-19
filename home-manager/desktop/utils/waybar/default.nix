{ config, ... }:
{
  config = {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        # target = "niri-session.target";
      };
    };

    # @todo Find how to not have to type the whole path
    home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/waybar/config";
  };
}
