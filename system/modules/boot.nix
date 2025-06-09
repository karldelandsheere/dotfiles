{ ... }:
{
  boot = {
    # We use Grub with Efi/Gpt
    # ------------------------
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "/dev/disk/by-uuid/__BOOT_UUID__";
        efiSupport = true;
        # efiInstallAsRemovable = true;
      };
    };

    initrd.systemd.enable = true;

    supportedFilesystems = [ 
      "btrfs"
      "fat" "vfat" "exfat"
      "ntfs" # Is it still needed though?
    ];
  };
}
