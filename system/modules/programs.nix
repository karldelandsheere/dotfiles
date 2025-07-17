{ config, lib, pkgs, ... }:
{
  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      brightnessctl
      curl
      git
      # gnupg
      helix
      jq
      libnotify
      libsecret
      nano
      pinentry
      unzip
      usbutils
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.gui.enable ) [
      nemo
      qt5.qtwayland
      qt6.qtwayland
      swaylock-effects
      wl-clipboard
      xwayland-satellite
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
      loginShellInit = ''
        source /run/agenix/unnamedplayer
      '';
    };
    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;


    # Shell agnostic aliases
    # ----------------------
    environment.shellAliases = {
      dots = "cd ${config.nouveauxParadigmes.dotfiles}";
      todo = "grep -rnw ${config.nouveauxParadigmes.dotfiles} -e '@todo'";
    };
  };
}
