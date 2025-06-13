{ config, ... }:
{
  config = {
    services.swayidle = {
      enable = true;
      timeouts = [
        { timeout = 10; command = "swaylock"; }
        { timeout = 30; command = "systemctl suspend"; }
      ];
      events = [
        { events = "before-sleep"; command = "swaylock"; }
        { events = "lock"; command = "swaylock"; }
      ];
    };

    # @todo Find how to not have to type the whole path
    home.file.".config/fuzzel".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/fuzzel/config";
  };
}
