{ ... }:
{
  imports = [
    ./programs
    ./desktop
  ];

  # It's the least, right?
  # ----------------------     
  programs.home-manager.enable = true;

  home = {
    username = "unnamedplayer";
    homeDirectory = "/home/unnamedplayer";
  };

  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;
}
