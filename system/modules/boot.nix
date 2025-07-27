{ config, pkgs, ... }:
{
  config = {
    boot = {
      kernelParams = [ "quiet" "splash" ];

      loader = {
        efi.canTouchEfiVariables = true;

        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          # gfxmodeEfi = "2880x1800";
          # theme = pkgs.catppuccin-grub;
          # theme = "/boot/grub/themes/test/grub/2880x1800/theme.txt";
          theme = pkgs.fetchFromGitHub {
            owner = "shvchk";
            repo = "fallout-grub-theme";
            rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
            sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
          };
        };
      };


      initrd = {
        enable = true;
        systemd.enable = true;
      };


      supportedFilesystems = [ 
        "btrfs"
        "fat" "vfat" "exfat"
        "hfsplus"
        "ntfs" # Do I still need this though?
      ];
    };
  };
}
