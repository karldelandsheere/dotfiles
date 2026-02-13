###############################################################################
#
# Nix/NixOS related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    options.nouveauxParadigmes = {
      # Philosophical vs pragramtic question...
      allowUnfree = lib.mkOption {
        type        = lib.types.bool;
        default     = true;
        description = "Allow unfree software to be installed? Defaults to true";
      };

      # Nix/NixOS version
      stateVersion = lib.mkOption {
        type        = lib.types.str;
        default     = "25.11";
        description = "Nix/NixOS version. Defaults to 25.11";
      };
    };
  
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

      nixpkgs.config.allowUnfree = cfg.allowUnfree;
      system.stateVersion = cfg.stateVersion;
    };
  };
}

