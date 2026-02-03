###############################################################################
#
# LUKS encryption for root partition.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.encryption = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
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
    };
  };
}
