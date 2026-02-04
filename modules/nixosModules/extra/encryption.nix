###############################################################################
#
# LUKS encryption for root partition.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.encryption = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
    users = [ "unnamedplayer" ]; # @todo Repair the users provisining
  in
  {
    # Related options and default values definition
    options.nouveauxParadigmes.encryption = {
      enable = lib.mkEnableOption "Use full disk encryption? Defaults to false.";
    };

    config = lib.mkIf cfg.encryption.enable {
      boot = {
        loader.grub = {
          enableCryptodisk = true;
          extraGrubInstallArgs = [ "--modules=cryptodisk luks" ];
        };

        initrd = {
          luks.devices.cryptroot = {
            allowDiscards = true;
            bypassWorkqueues = true;
            # preLVM = true; # @todo Determine if I should enable this
          };
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
