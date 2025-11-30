{ config, lib, pkgs, ... }:
{
  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      curl
      helix
      jq
      libsecret
      nix-tree
      pinentry-curses
      progress
      scooter
      tree
      unzip
      usbutils
    ];

    programs.dconf.enable = true;

    # Git is needed for at least maintaining these dotfiles
    # -----------------------------------------------------
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


    # Also, I'm using Helix
    # ---------------------
    environment.variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
    

    # Shell agnostic aliases
    # ----------------------
    environment.shellAliases = {
      dots = "cd ${config.nouveauxParadigmes.dotfiles}";
      todo = "grep -rnw ${config.nouveauxParadigmes.dotfiles} -e '@todo'";
    };
  };
}
