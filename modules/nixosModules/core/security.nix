###############################################################################
#
# Security/hardening related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, pkgs, ...}: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
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

      environment = {
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
          users = lib.listToAttrs ( map ( username: {
            name = username; value = {
              directories = [
                ".gnupg"                    # PGP utility
                ".local/share/keyrings"     # Gnome keyring
              ];
            };
          } ) ( lib.lists.unique ( users ) ) );
        };
      };
    };
  };
}

