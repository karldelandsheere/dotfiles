{ config, lib, pkgs, ... }:
{
  imports = [];


  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      # bluez
      brightnessctl
      curl
      git
      helix
      libnotify
      nano
      nemo
      networkmanagerapplet
      qt5.qtwayland
      qt6.qtwayland
      swaylock-effects
      unzip
      wl-clipboard
      xwayland-satellite
    ];

    programs.dconf.enable = true;

    # Git is needed for at least maintaining these dotfiles
    # -----------------------------------------------------
    programs.git.enable = true;


    # I like zsh better
    # -----------------
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;


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
