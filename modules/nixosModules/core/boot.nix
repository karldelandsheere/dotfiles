###############################################################################
#
# Boot related config.
#
# So far it's some basic stuff, and grub theming.
#
# That being said, should I keep grub theming here?
# It's not really a core thing. Is it?
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, pkgs, ...}:
  {
    config = {
      boot = {
        kernelParams = [ "splash" ];

        loader = {
          efi.canTouchEfiVariables = true;

          grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
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

        supportedFilesystems = [ "btrfs" "fat" "vfat" "exfat" "hfsplus" "ntfs" ];
      };

      environment = {
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
          files = [ "/etc/machine-id" ];
        };
      };
    };
  };
}

