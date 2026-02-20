###############################################################################
#
# System, host, user, ... all possible preferences are listed and defined here.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}:
  {
    options = {
      features = {
        desktop.enable = lib.mkEnableOption "Enable desktop environment? Defaults to false.";

        encryption.enable = lib.mkEnableOption "Encrypt the whole system? Defaults to false.";

        hibernation = {
          enable = lib.mkEnableOption "Enable hibernation? Defaults to false.";

          # @todo this should be determined in install.sh
          resumeOffset = lib.mkOption {
            type = lib.types.str;
            default = "0";
            description = "Offset to resume after hibernation. \
                           Defaults to 0. To find the value, use: \
                           sudo btrfs inspect-internal map-swapfile -r /swap/swapfile";
          };
        };

        impermanence.enable = lib.mkEnableOption "Use impermanence? Defaults to false.";
      };
      
      filesystem = {
        dotfiles = lib.mkOption {
          type = lib.types.str;
          default = "/etc/nixos";
          description = "Path to NixOS dotfiles. Defaults to /etc/nixos";
        };

        root = lib.mkOption {
          type = lib.types.str;
          default = "/dev/mapper/cryptroot";
          description = "Which is the root vol?";
        };

        swapSize = lib.mkOption {
          type        = lib.types.int;
          default     = lib.mkDefault 8*1024; # 8GB is a good default value, right?
          description = "Size of swapfile. Defaults to 8*1024.";
        };
      };
    };
  };
}

