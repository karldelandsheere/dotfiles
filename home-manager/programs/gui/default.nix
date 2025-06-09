{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./terminal.nix
  # ] ++ lists.optionals (system == 'x86_64-linux') [
    ./onlyoffice.nix
  ];

  home.packages = with pkgs; [
    bitwarden
    nautilus
    openscad
    prusa-slicer
    #qbittorrent
    signal-desktop
    thunderbird
    #vlc
  # ] ++ lists.optionals (system == 'x86_64-linux') [
    anytype
  ];
}
