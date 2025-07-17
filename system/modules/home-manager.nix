# Home-manager setup
# ------------------
{ config, lib, inputs, pkgs, ... }:
{
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
