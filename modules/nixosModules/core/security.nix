###############################################################################
#
# Security/hardening related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      security = {
        polkit.enable = true;
        rtkit.enable = true;

        # Allow running shutdown and reboot as root without a password
        sudo.extraRules = [ {
          groups = [ "wheels" ];
          commands = lib.forEach [ "reboot" "shutdown" ] ( cmd: {
            command = "/run/current-system/sw/bin/${cmd}";
            options = [ "NOPASSWD" "SETENV" ];
          } );
        } ];
      };

      services.gnome.gnome-keyring.enable = true;
    };
  };
}

