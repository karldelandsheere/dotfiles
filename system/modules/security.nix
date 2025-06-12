{ ... }:

{
    # Security stuff
    # --------------
    security = {
      # Read somewhere that it was better to set that, but why?
      sudo.extraConfig = ''
        Defaults lecture = never
      '';

      polkit.enable = true; # at first, enabled for hyprland, still needed?
      pam.services = {
        swaylock = {}; # init I guess?
        swaylock.fprintAuth = false;
      };
    };
}

