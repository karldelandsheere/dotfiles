{ config, ... }:
{
  config = {
    programs = {
      wlogout = {
        enable = true;
        # layout = [
        #   {
        #     label = "lock";
        #     action = "swaylock -f";
        #     text = "Lock";
        #     keybind = "l";
        #   }

        #   {
        #     label = "hibernate";
        #     action = "systemctl hibernate";
        #     text = "Hibernate";
        #     keybind = "h";
        #   }
          
        #   {
        #     label = "logout";
        #     action = "swaylock -f";
        #     text = "Logout";
        #     keybind = "o";
        #   }

        #   {
        #     label = "shutdown";
        #     action = "systemctl poweroff";
        #     text = "Shutdown";
        #     keybind = "s";
        #   }

        #   {
        #     label = "suspend";
        #     action = "systemctl suspend";
        #     text = "Suspend";
        #     keybind = "s";
        #   }

        #   {
        #     label = "reboot";
        #     action = "systemctl reboot";
        #     text = "Reboot";
        #     keybind = "r";
        #   }
        # ];
      };
    };

    
    # @todo Find how to not have to type the whole path
    home.file.".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/wlogout/config";
    # home.file.".config/wlogout/style.css".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/wlogout/config/style.css";
    # home.file.".config/wlogout/icons".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/desktop/utils/wlogout/config/icons";
  };
}
