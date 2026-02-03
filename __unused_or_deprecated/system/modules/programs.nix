{ config, lib, pkgs, ... }: let
  cfg = config.nouveauxParadigmes;
in
{
  config = {
    # Shell aliases
    environment.shellAliases = {
      dots = "cd ${cfg.dotfiles}";
      keycodes = "xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'";

      # Git shortcuts for the lazy ass I am
      ga    = "git add";
      gaa   = "git add --all";
      gaacm = "git add --all && git commit -S -m";
      gb    = "git branch";
      gc    = "git commit -S";
      gch   = "git checkout";
      gchb  = "git checkout -b";
      gcl   = "git clone";
      gcm   = "git commit -S -m";
      gd    = "git diff";
      gm    = "git merge";
      gpl   = "git pull";
      gplo  = "git pull origin";
      gps   = "git push";
      gpso  = "git push origin";
      gs    = "git status";
    };
  };
}
