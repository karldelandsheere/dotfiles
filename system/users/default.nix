{ config, pkgs, ... }:
{
  config = {
    # That's me
    # ---------
    users.users.unnamedplayer = {
      uid = 1312;
      hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
      isNormalUser = true;
      extraGroups = [
        "wheel"

        "audio"
        "input"
        "networkmanager"
        # "openrazer"
        "plugdev"
        "video"
      ];
    };


    # Allow running shutdown and reboot as root without a password
    # ------------------------------------------------------------
    security.sudo.extraRules = [
      {
        users = [ "unnamedplayer" ];
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
}
