{ config, ... }:
{
  config = {
    services.swayidle = {
      enable = true;
      # timeouts = [
      #   { timeout = 10; command = "niri msg action power-off-monitors"; }
      #   { timeout = 30; command = "systemctl suspend"; }
      # ];
      # events = [
      #   { event = "before-sleep"; command = "swaylock -f"; }
      #   { event = "lock"; command = "swaylock -f"; }
      # ];
    };

    # @todo Find how to not have to type the whole path
    home.file.".config/swayidle".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/swayidle/config";
  };
}
