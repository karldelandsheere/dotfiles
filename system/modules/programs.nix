{ config, lib, pkgs, ... }:
{
  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      bitwarden-cli # Easy access to my vault from the tty
      bottom # Process/system monitor
      curl
      fastfetch # (am I a cool kid now?)
      # git # Git is needed for at least maintaining these dotfiles
      helix # Helix > vim imho
      jq
      libsecret
      nix-tree
      pinentry-curses
      progress
      scooter
      tree
      ueberzugpp # Terminal image viewer (only for yazi so far)
      unzip
      usbutils
      yazi # A really cool CLI file explorer
    ];


    programs.dconf.enable = true;

    programs.git.enable = true;

    programs.gnupg.agent = {
      enable           = true;
      pinentryPackage  = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };


    # I use zsh because I'm edgy but not too much
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
      todo = "grep -rnw ${config.nouveauxParadigmes.dotfiles} -e '@todo'";

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
