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
    };

    services.gnome.gnome-keyring.enable = true;
  };
}

