{ ... }:

{
  boot = {
    loader.grub = {
      enableCryptodisk = true;
      extraGrubInstallArgs = [ "--modules=cryptodisk luks" ];
    };

    initrd = {
      luks.devices.cryptroot = {
        allowDiscards = true;
        bypassWorkqueues = true;
        preLVM = true;
      };

      systemd.services.rollback.after = [ "systemd-cryptsetup@cryptroot.service" ];
    };
  };
}
