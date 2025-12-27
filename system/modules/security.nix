###############################################################################
# 
# Security related stuff
# 
###############################################################################

{ config, lib, ... }:
{
  config = {
    security = {
      polkit.enable = true;
      rtkit.enable  = true;

      # Allow running shutdown and reboot as root without a password
      sudo.extraRules = [
        {
          groups = [ "wheels" ];
          commands = lib.forEach [ "reboot" "shutdown" ] ( cmd: {
            command = "/run/current-system/sw/bin/${cmd}";
            options = [ "NOPASSWD" "SETENV" ];
          } );
        }
      ];
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
