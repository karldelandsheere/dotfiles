{ config, lib, inputs, ... }:
{
  imports = [
    ./programs
    ./utils
    ./wm/niri
  ];


  config = {
    home = {
      username = "unnamedplayer";
      homeDirectory = "/home/unnamedplayer";

      # Opt-in what files and directories should persist
      # ------------------------------------------------
      persistence."/persist/home/unnamedplayer" = {
        directories = [
          # ".config/Element"
          # ".config/Signal"
          ".gnupg"
          ".local/share/keyrings"
          # ".mozilla/firefox/default"
          ".mullvad"
          ".ssh"

          # "OpenCloud"
        ];

        files = [
          # ".config/mimeapps.list"
          ".zsh_history"
        ];

        allowOther = true;
      };
    };

    # age = {
    #   identityPaths = [ "/home/unnamedplayer/.ssh/id_ed25519" ];
    #   secrets = {
    #     unnamedplayer.file = ../secrets/unnamedplayer-secrets.age;
    #   };
    # };
  };
}
