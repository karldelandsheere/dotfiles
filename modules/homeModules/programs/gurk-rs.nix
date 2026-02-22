###############################################################################
#
# Gurk-rs is a tty client for Signal
#   (the privacy focused messaging platform and protocol).
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.gurk-rs = { config, osConfig, lib, pkgs, ... }:
  {
    config = {
      # # this allows you to access `unstable` anywhere in your config
      # # https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
      nixpkgs.overlays = [ (final: _: {
        # this allows you to access `pkgs.unstable` anywhere in your config
        unstable = import inputs.unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (final) config;
        };
      } ) ];
      
      programs.gurk-rs = { # @todo fix images and transfer
        enable = true;
        package = pkgs.unstable.gurk-rs;
        settings = {
          bell = true;
          colored_messages = false;
          data_dir = "${config.home.homeDirectory}/.local/share/gurk";
          default_keybindings = true;
          first_name_only = false;
          keybindings =  {};
          show_receipts = true;
          user = { # @todo Move this to secrets
            name = "Karl";
            phone_number = "+32498139866";
          };
        };
      };

      # What data should persist
      home.persistence."/persist" = lib.mkIf osConfig.features.impermanence.enable {
        directories = [ ".local/share/gurk" ]
      };
    };
  };
}
