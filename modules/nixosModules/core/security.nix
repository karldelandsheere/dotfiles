###############################################################################
#
# Security/hardening related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    
    config = {
      # GNU Privacy Guard / OpenPGP
      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-curses;
        enableSSHSupport = true;
      };
      
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

