{ config, lib, pkgs, ... }:
{
  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      curl
      git                    # Git is required to manage these dotfiles
      helix                  # Helix > Vim imho
      jq                     # Like sed but for json, needed for persist.sh
      libsecret
      nix-tree               # Nix dependencies browser
      unzip
      usbutils
      xev                    # Event monitor, for debugging
    ];


    programs.gnupg.agent = {
      enable           = true;
      pinentryPackage  = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };


    # Zsh because I'm edgy but not too much
    # -------------------------------------------
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      # loginShellInit = ''
      #   source /run/agenix/unnamedplayer
      # '';
    };
    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;


    # Also, Helix > vim imho
    # ----------------------
    environment.variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };


    # Shell agnostic aliases
    # ----------------------
    environment.shellAliases = {
      dots = "cd ${config.nouveauxParadigmes.dotfiles}";
      todo = "clear && grep -rnw ${config.nouveauxParadigmes.dotfiles} --exclude-dir=__unused_or_deprecated -e '@todo'";
      keycodes = "xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'";

      # Git shortcuts for the lazy ass I am
      ga = "git add";
      gaa = "git add --all";
      gaacm = "git add --all && git commit -S -m";
      gb = "git branch";
      gc = "git commit -S";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcl = "git clone";
      gcm = "git commit -S -m";
      gd = "git diff";
      gm = "git merge";
      gpl = "git pull";
      gplo = "git pull origin";
      gps = "git push";
      gpso = "git push origin";
      gs = "git status";
    };
  };
}
