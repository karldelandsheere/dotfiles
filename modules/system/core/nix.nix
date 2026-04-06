###############################################################################
#
# Nix related config.
#
###############################################################################

{ inputs, self, ... }: let
  experimental-features = [ "nix-command" "flakes" ]; # Activate flakes, etc.
  _gc = options: {
    inherit options;
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "1 hour";
  };
in
{
  # Import and enable flake.modules
  imports = [ inputs.flake-parts.flakeModules.modules ];
  
  # Apply this on all systems
  perSystem = { config, nixpkgs, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = false;
        # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];
      };
    };
  };
  
  flake.modules = {
    nixos.core = { lib, config, ... }: {
      config = {
        nix = {
          gc = _gc "--delete-older-than 30d --keep-generations 10";
        
          settings = {
            inherit experimental-features;
            auto-optimise-store = true;
            trusted-users = [ "@wheel" ];
            warn-dirty = false; # For some reason, it still does...
          };
        };

        # Ressources to persist
        features.impermanence.persist = {
          directories = [
            "/etc/nixos"
            "/var/lib/nixos"
          ];

          files = [ "/root/.local/share/nix/trusted-settings.json" ];

          users = lib.listToAttrs ( map ( username: {
            name = username; value = {
              files = [ ".local/share/nix/trusted-settings.json" ];
            };
          } ) ( lib.lists.unique ( config.core.users ) ) );
        };

        system.stateVersion = lib.mkDefault "25.11";
      };
    };

    darwin.core = { lib, ... }: {
      config = {
        nix = {
          gc = _gc "--delete-older-than 15d";

          settings = {
            inherit experimental-features;
          };
        };
      
        system.stateVersion = lib.mkDefault "25.11";
      };
    };
  };
}

