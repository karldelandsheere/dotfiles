{ config, lib, pkgs, ... }:
{
  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      bitwarden-cli          # Easy access to my vault from the tty
      bottom                 # Process/system monitor
      curl
      fastfetch              # (am I a cool kid now?)
      git                    # Git is required to manage these dotfiles
      helix                  # Helix > vim imho
      jq                     # sed for json
      libsecret
      nix-tree               # Nix dependencies browser
      # pinentry-curses        # Needed for gnupg
      progress               # Follow the progression of any script
      scooter                # Search & replace
      tree                   # Display a tree of a given folder
      ueberzugpp             # Terminal image viewer (needed for yazi)
      unzip
      usbutils
      xev                    # Event monitor, for debugging
      yazi                   # A really cool CLI file explorer
    ];



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
