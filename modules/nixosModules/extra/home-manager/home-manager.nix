###############################################################################
# 
# Home-manager setup.
#
# Next steps:
#   - @todo Figure out what should be moved to Home-Manager instead of
#       system, in terms of packages, programs, and stuff.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.home-manager = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
  in
  {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    # Related options and default values definition
    options.nouveauxParadigmes.homeManager = {
      enable = lib.mkOption {
        type        = lib.types.bool;
        default     = true;
        description = "Do we use Home-Manager? Defaults to true.";
      };
    };

    config = lib.mkIf cfg.homeManager.enable {
      home-manager = {
        useUserPackages     = true;
        extraSpecialArgs    = { inherit inputs; };
        backupFileExtension = "backup";

        sharedModules = [
          {
            programs.home-manager.enable = true;   # Enable home-manager
            home.stateVersion            = config.system.stateVersion;
            news.display                 = "show"; # Display the news at rebuild
          }

          inputs.agenix.homeManagerModules.default

        ] ++ lib.lists.optionals ( cfg.gui.enable ) [
          ../../../../system/modules/home-manager/niri.nix      # Compositor
          ../../../../system/modules/home-manager/noctalia.nix  # Quickshell integration
        ];
      };
    };
  };
}
