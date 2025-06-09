{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    # ./onlyoffice.nix # only if x86_64-linux
    ./terminal.nix
  ];

  home.packages = with pkgs; [
    # anytype # only if x86_64-linux
    bitwarden
    nautilus
    openscad
    prusa-slicer
    #qbittorrent
    signal-desktop
    thunderbird
    #vlc
  ];
}
