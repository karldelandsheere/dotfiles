###############################################################################
#
# LUKS encryption for root partition.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.encryption = { lib, config, ... }: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisining
  in
  {
    config = {
      features.encryption.enable = true; # So other modules know
      
      boot = {
        loader.grub = {
          enableCryptodisk = true;
          extraGrubInstallArgs = [ "--modules=cryptodisk luks" ];
        };

        initrd.luks.devices.cryptroot = {
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };

      # If the whole system is encrypted and password protected at boot,
      # and there's only one user, no need for a second login screen right after
      services.getty = lib.mkIf (lib.length users == 1) {
        autologinUser = "${lib.head users}";
      };
    };
  };
}
