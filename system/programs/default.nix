{ config, lib, pkgs, ... }:
{
  imports = [
    ./hyprland.nix
  ];


  # Git is needed for at least maintaining these dotfiles
  # -----------------------------------------------------
  programs.git.enable = true;


  config = {
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
