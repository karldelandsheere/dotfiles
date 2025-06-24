{ ... }:

{
    # Security stuff
    # --------------
    security = {
      polkit.enable = true; # at first, enabled for hyprland, still needed?
      pam.services = {
        swaylock = {}; # init I guess?
        swaylock.fprintAuth = false;
      };
    };
}

