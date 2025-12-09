###############################################################################
# 
# Home-manager setup.
#
# Next steps:
#   - @todo Figure out what should be moved to Home-Manager instead of
#       system, in terms of packages, programs, and stuff.
#
###############################################################################

{ config, lib, inputs, pkgs, ... }:
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    homeManager.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Do we use Home-Manager? Defaults to true.";
    };
  };


  config = lib.mkIf config.nouveauxParadigmes.homeManager.enable {
    home-manager = {
      # General stuff
      # -------------
      useUserPackages     = true;
      extraSpecialArgs    = { inherit inputs; };
      backupFileExtension = "backup";

      sharedModules = [
        # inputs.agenix.homeManagerModules.default
        {
          # Enable home-manager
          # -------------------
          programs.home-manager.enable = true;
          
          # Sync with nixOS stateVersion
          # ----------------------------
          home.stateVersion = config.system.stateVersion;

          # Display the news at rebuild
          # ---------------------------
          news.display = "show";
        }
      ] ++ lib.lists.optionals ( config.nouveauxParadigmes.impermanence.enable ) [
        inputs.impermanence.homeManagerModules.impermanence
      ];

      # For the moment, I'm the only user so I leave it like this
      # ---------------------------------------------------------
      users.unnamedplayer = { imports = [ ../../home-manager ]; };
    };
  };
}
