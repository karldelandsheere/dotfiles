{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./zsh.nix
  ];


  programs.helix = {
    enable = true;
    defaultEditor = true;
  };


  home.packages = [ pkgs.scooter ];
}
