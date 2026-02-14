###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
  homeDirectory = "/home/${username}";
in
{
  flake.homeModules.${username} = { config, pkgs, osConfig, lib, inputs, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    # @todo When I'll start wrapping programs, set impermanence for each in their respective files
    config.home.persistence."/persist" = {
      directories = [
        "Data"                           # Vaults, documents, etc

        ".local/share/prusa-slicer"

        # @todo Determinate what is really needed here
        # ".local/share/calcurse"
        # ".local/share/iamb"
      ]
      ++ lib.forEach [
        "Bitwarden"
        "obsidian"
        "PrusaSlicer"
        "Termius"
        "vivaldi"
        "zed"
      ] (x: ".config/${x}");


      files = [
        # ".config/mimeapps.list"
        # ".config/Bitwarden CLI/data.json"
      ];
    };
  };
}
