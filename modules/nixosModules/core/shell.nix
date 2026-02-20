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

        shellAliases = {
          dots = "cd ${cfg.dotfiles}";
          todo = "clear && grep -rnw ${cfg.dotfiles} --exclude-dir=__unused_or_deprecated -e '@todo'";
          keycodes = "xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'";
        };
        
        systemPackages = with pkgs; [
          curl 
          git             # Git is required to manage these dotfiles
          helix           # Helix > Vim imho
          jq              # Like sed but for json, needed for persist.sh
          libsecret
          nix-tree        # Nix dependencies browser
          progress        # Follow the progression of any command
          scooter         # Directory wide search & replace
          tmux            # Terminal multiplexer
          tree            # Kinda ls but as a tree
          ueberzugpp      # Terminal image viewer (needed for yazi)
          unzip
          usbutils
          xev             # Event monitor, for debugging
          yazi            # A really cool CLI file explorer
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
