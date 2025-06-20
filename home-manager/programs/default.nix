{ ... }:
{
  imports = [
    ./cli
    ./gui
  ];

  nixpkgs.config.allowUnfree = true;
}
