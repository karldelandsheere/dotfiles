###############################################################################
#
# So far, it's a one user system. I'll need to reorganize that when
# this changes. I should probably reorganize it anyway though.
#
###############################################################################

{ config, osConfig, lib, inputs, ... }: let
  username = "${osConfig.nouveauxParadigmes.user.name}";
in
{
  imports = [
    ../config      # All the configs for tty and gui apps
    ./tty          # No matter what, we'll always have a tty
  ] ++ lib.lists.optionals ( osConfig.nouveauxParadigmes.gui.enable ) [ ./gui ];


  config = {
    home = {
      username      = "${username}";
      homeDirectory = "/home/${username}";

      # Opt-in what files and directories should persist
      # ------------------------------------------------
      persistence."/persist/home/${username}" = {
        directories = [
          "Data"                           # Vaults, documents, etc
        ];
        # ++ lib.forEach [
        #   "Bitwarden"
        #   "obsidian"
        #   "PrusaSlicer"
        #   "Signal"
        #   "Termius"
        #   "vivaldi"
        #   "VSCodium"
        # ] (x: ".config/${x}");

        files = [
        #   # ".config/mimeapps.list"
        #   # ".config/Bitwarden CLI/data.json"
        ];

        
      };
    };


    # Shouldn't it be enough to set it once in the system part of the config?
    # -----------------------------------------------------------------------
    nixpkgs.config.allowUnfree = osConfig.nouveauxParadigmes.allowUnfree;
  };
}
