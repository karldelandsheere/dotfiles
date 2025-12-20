{ config, ... }:
{
  config = {
    # Opt-in what files and directories should persist
    home.persistence."/persist/home/unnamedplayer" = {
      directories = [
        "Data"                           # Vaults, documents, etc
            
        ".local/share/prusa-slicer"
        ".vscode-oss"
        ".librewolf"

        ".cache/noctalia"

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
        "VSCodium"
      ] (x: ".config/${x}");


      files = [
        # ".config/mimeapps.list"
        # ".config/Bitwarden CLI/data.json"
      ];

      allowOther = true;
    };
  };
}
