{ pkgs, ... }:
{
  boot = {
    # We use Grub with Efi/Gpt
    # ------------------------
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "2880x1800";
        # theme = pkgs.catppuccin-grub;
        # theme = "/boot/grub/themes/test/grub/2880x1800/theme.txt";
      };
    };

    initrd = {
      enable = true;
      systemd.enable = true;
    };

    supportedFilesystems = [ 
      "btrfs"
      "fat" "vfat" "exfat"
      "ntfs" # Is it still needed though?
    ];
  };
}
