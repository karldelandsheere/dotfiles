{ config, lib, ... }:
{
  config = {
    # Opt-in what files and directories should persist
    home.persistence."/persist" = {
      directories = [
        "Data"                           # Vaults, documents, etc
            
        ".local/share/prusa-slicer"

        # @todo Determinate what is really needed here
        # ".local/share/calcurse"
        # ".local/share/gurk"
        # ".local/share/iamb"
      ]
      ++ lib.forEach [
        "Bitwarden"
        "obsidian"
        "PrusaSlicer"
        "Signal"
        "Termius"
        "vivaldi"
        "zed"
      ] (x: ".config/${x}");


      files = [
        ".config/gurk/gurk.toml"
        # ".config/mimeapps.list"
        # ".config/Bitwarden CLI/data.json"
      ];
    };
  };
}
