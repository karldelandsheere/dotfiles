{ config, pkgs, ... }:
{
  # That's me
  # ---------
  users.users.unnamedplayer = {
    uid = 1312;
    hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "audio" ];
    # openssh.authorizedKeys.keys = [];
  };

  # users.users.root.openssh.authorizedKeys.keys =
  #   config.users.users.unnamedplayer.openssh.authorizedKeys.keys;


  # Allow running nixos-rebuild, shutdown, and reboot as root without a password.
  environment.systemPackages = [ pkgs.nixos-rebuild ];
  security.sudo.extraRules = [
    {
      users = [ "unnamedplayer" ];
      commands = [
        { command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" "SETENV" ];
        }

        { command = "${pkgs.systemd}/bin/systemctl";
          options = [ "NOPASSWD" "SETENV" ];
        }

        # reboot and shutdown are symlinks to systemctl,
        # but need to be authorized in addition to the systemctl binary
        # to allow nopasswd sudo
        { command = "/run/current-system/sw/bin/shutdown";
          options = [ "NOPASSWD" "SETENV" ];
        }

        { command = "/run/current-system/sw/bin/reboot";
          options = [ "NOPASSWD" "SETENV" ];
        }           
      ];
    }
  ];
}
