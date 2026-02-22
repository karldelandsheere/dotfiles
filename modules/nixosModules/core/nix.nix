###############################################################################
#
# Nix/NixOS related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
  in
  {
    config = {
      nix = {
        settings = {
          auto-optimise-store = true;
          experimental-features = [ "nix-command" "flakes" ]; # Activate flakes, etc.
          trusted-users = [ "@wheel" ];
          warn-dirty = false; # For some reason, it still does...
        };
    
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d --keep-generations 10";
          randomizedDelaySec = "1 hour";
        };
      };

      nixpkgs.config = {
        allowUnfree = false;
        # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];
      };

      environment = {
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
          directories = [
            "/etc/nixos"
            "/var/lib/nixos"
          ];

          files = [ "/root/.local/share/nix/trusted-settings.json" ];

          users = lib.listToAttrs ( map ( username: {
            name = username; value = {
              files = [ ".local/share/nix/trusted-settings.json" ];
            };
          } ) ( lib.lists.unique ( users ) ) );
        };
      };
    };
  };
}

