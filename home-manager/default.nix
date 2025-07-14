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
  };
}
