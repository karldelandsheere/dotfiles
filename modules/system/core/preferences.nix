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
      core = {
        mainUser = lib.mkOption {
          type = lib.types.str;
          default = "unnamedplayer";
          description = "Main user of the host.";
        };

        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Registered users on the host.";
        };
      };

      features = {
        desktop.enable = lib.mkEnableOption "Enable desktop environment? Defaults to false.";

        encryption.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Encrypt the whole system? Defaults to true.";
        };

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

        impermanence = {
          enable = lib.mkEnableOption "Use impermanence? Defaults to false.";

          # The idea is to tidy up the code of the other modules.
          # You want to persist something? Do it.
          # Wether impermanence is enabled or not, just add to the list.
          # And if it is enabled, then the feature module will take care of it.
          # So, no need to check if it's enabled 100 times.
          persist = let
            stuff = {
              directories = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [];
                description = "List of directories to persist.";
              };

              files = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [];
                description = "List of files to persist.";
              };
            };

            # userStuff = lib.mkSubModule {
            #   inherit (stuff) directories files;
            # };
          in
          {
            inherit (stuff) directories files;

            # @todo Make this work for users' stuff too
            users = lib.mkOption {
                type = lib.types.attrsOf ( lib.types.submodule {
                  options = {
                    inherit (stuff) directories files;
                  };
                } );
                default = {};
                description = "List of users' stuff to persist.";
            };
          };
        };
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

