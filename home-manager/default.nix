{ ... }:
{
  imports = [
    ./programs
    ./desktop
  ];

  # It's the least, right?
  # ----------------------     
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
