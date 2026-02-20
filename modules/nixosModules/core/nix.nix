###############################################################################
#
# Nix/NixOS related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}:
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
    };
  };
}

