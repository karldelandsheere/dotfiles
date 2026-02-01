{ inputs, self, ... }:
{
  config = {
    flake.nixosModules.core = { config, ...}: let
      cfg = config.nouveauxParadigmes;
    in
    {
      # Nix options
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

      nixpkgs.config.allowUnfree = cfg.allowUnfree;  # Whether to allow unfree software or not
    };
  };
}

