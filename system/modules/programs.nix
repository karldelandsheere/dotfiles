{ config, lib, pkgs, ... }:
{
  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      brightnessctl
      curl
      git
      helix
      libnotify
      libsecret
      nano
      unzip
      usbutils
    ] ++ lib.lists.optionals ( config.gui.enable ) [
      nemo
      qt5.qtwayland
      qt6.qtwayland
      # razergenie
      swaylock-effects
      wl-clipboard
      xwayland-satellite
    ];

    programs.dconf.enable = true;

    # Git is needed for at least maintaining these dotfiles
    # -----------------------------------------------------
    programs.git.enable = true;


    # I use zsh because I'm edgy but not too much
    # -------------------------------------------
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;


    # Shell agnostic aliases
    # ----------------------
    environment.shellAliases = {
      dots = "cd ${config.dotfiles}";
      todo = "grep -rnw ${config.dotfiles} -e '@todo'";
    };


    # Activate flakes, etc.
    # ---------------------
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@wheel" ];
      warn-dirty = false;
    };


    # I'd like it to be false, but that's not for today is it?
    # --------------------------------------------------------
    nixpkgs.config.allowUnfree = true;
  };
}
