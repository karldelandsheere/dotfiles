# LUKS encryption for root partition
# ----------------------------------
{ config, lib, ... }:
{
  config = lib.mkIf config.nouveauxParadigmes.encryption.enable {
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

        # systemd.services.rollback.after =
        #   lib.lists.optionals ( config.nouveauxParadigmes.impermanence.enable )
        #   [ "systemd-cryptsetup@cryptroot.service" ];
      };
    };
  };
}
