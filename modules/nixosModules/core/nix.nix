###############################################################################
#
# Nix related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    # Philosophical vs pragramtic question...
    options.nouveauxParadigmes.allowUnfree = lib.mkOption {
        type        = lib.types.bool;
        default     = true;
        description = "Allow unfree software to be installed? Defaults to true";
    };
  
    config = {
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

      nixpkgs.config.allowUnfree = cfg.allowUnfree;
    };
  };
}

