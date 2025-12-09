###############################################################################
#
# LUKS encryption for root partition.
#
###############################################################################

{ config, lib, ... }:
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    encryption.enable = lib.mkEnableOption "Use full disk encryption? Defaults to false.";
  };
  

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
