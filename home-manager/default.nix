{ config, inputs, ... }:
{
  imports = [
    ./programs
    ./utils
    ./wm/niri

    inputs.impermanence.homeManagerModules.impermanence
  ];


  config = {
    # It's the least, right?
    # ----------------------     
    programs.home-manager.enable = true;


    # If I'm going to get this notification each time
    # at least let me check those damn news
    # ------------------------------------- 
    news.display = "show";


    # Home-manager version
    # --------------------
    home.stateVersion = "25.05";
    

    # For the moment, I'm the only user
    # so I leave this here
    # -------------------- 
    home = {
      username = "unnamedplayer";
      homeDirectory = "/home/unnamedplayer";

      # Opt-in what files and directories should persist
      # ------------------------------------------------
      persistence."/persist/home/unnamedplayer" = {
        directories = [
          "OpenCloud"
          ".ssh"
        ];

        files = [
          ".zsh_history"
          ".config/mimeapps.list"
          ".config/Signal/ephemeral.json"
          ".config/Signal/config.json"
        ];

        allowOther = true;
      };
    };
  };
}
