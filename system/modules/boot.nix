{ pkgs, ... }:
{
  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

    # We use Grub with Efi/Gpt
    # ------------------------
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
#        device = "/dev/disk/by-uuid/652D-1F87";
        device = "nodev";
        efiSupport = true;
        # efiInstallAsRemovable = true;
        gfxmodeEfi = "2880x1800";
        # theme = pkgs.catppuccin-grub;
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
