{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./zsh.nix
  ];


  # Helix
  # -----
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  home.sessionVariables.EDITOR = "hx";


  # Other CLI tools
  # ---------------
  home.packages = with pkgs; [
    cmatrix # like the cool guys
    fastfetch
    hugo
    scooter
  ];
}
