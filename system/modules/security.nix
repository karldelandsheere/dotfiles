# Security stuff
# --------------
{ config, ... }:
{
  config = {
    security = {
      polkit.enable = true;
      pam.services = {
        swaylock = {}; # init I guess?
        swaylock.fprintAuth = false;
      };

      # Allow running shutdown and reboot as root without a password
      # ------------------------------------------------------------
      sudo.extraRules = [
        {
          groups = [ "wheels" ];
          # users = [ "unnamedplayer" ];
          commands = [
            # reboot and shutdown are symlinks to systemctl,
            # but need to be authorized in addition to the systemctl binary
            # -------------------------------------------------------------
            { command = "/run/current-system/sw/bin/shutdown";
              options = [ "NOPASSWD" "SETENV" ]; }

            { command = "/run/current-system/sw/bin/reboot";
              options = [ "NOPASSWD" "SETENV" ]; }
          ];
        }
      ];
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
