###############################################################################
# 
# Home-manager setup.
#
# Next steps:
#   - @todo Figure out what should be moved to Home-Manager instead of
#       system, in terms of packages, programs, and stuff.
#
###############################################################################

{ config, lib, inputs, pkgs, ... }: let
  cfg = config.nouveauxParadigmes;
in
{
  imports = [
    # ...
  ] ++ lib.lists.optionals ( cfg.gui.enable ) [ ./gui.nix ];
  
  
  # Related options and default values definition
  options.nouveauxParadigmes = {
    homeManager.enable = lib.mkOption {
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
        # inputs.agenix.homeManagerModules.default
        {
          # Enable home-manager
          programs.home-manager.enable = true;
          
          # Sync with nixOS stateVersion
          home.stateVersion = config.system.stateVersion;

          # Display the news at rebuild
          news.display = "show";
        }
      ] ++ lib.lists.optionals ( cfg.impermanence.enable ) [
        inputs.impermanence.homeManagerModules.impermanence
      ];

      # Shouldn't it be enough to set it once in the system part of the config?
      # nixpkgs.config.allowUnfree = cfg.allowUnfree;

      # Import all user specific config
      # users = lib.genAttrs allUsers ( username: {
      #   imports = [ ../../users/${username}/home-manager.nix ];
      # } );
    };
  };
}
