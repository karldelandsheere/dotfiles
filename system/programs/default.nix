{ config, lib, pkgs, ... }:
{
  imports = [
    ./hyprland.nix
  ];


  config = {
    # System-wide packages
    # --------------------
    environment.systemPackages = with pkgs; [
      brightnessctl
      curl
      git
      helix
      nano
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
