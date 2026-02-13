###############################################################################
#
# Basic common things for the shell config.
# -> Zsh + Helix + the little things that help me get through the day.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      environment = {
        shells = [ pkgs.zsh ];
        
        systemPackages = with pkgs; [
          curl 
          git             # Git is required to manage these dotfiles
          helix           # Helix > Vim imho
          jq              # Like sed but for json, needed for persist.sh
          libsecret
          nix-tree        # Nix dependencies browser
          tmux            # Terminal multiplexer
          unzip
          usbutils
          xev             # Event monitor, for debugging
        ];

        variables = with pkgs; {
          EDITOR = "${helix}/bin/hx";
          VISUAL = "${helix}/bin/hx";
        };
      };

      # Zsh because I'm edgy but not too much
      programs.zsh = {
        enable = true;
        autosuggestions.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };

      users.defaultUserShell = pkgs.zsh;
    };
  };
}
