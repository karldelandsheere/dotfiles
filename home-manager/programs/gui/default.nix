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
    blender
    element-desktop
    nautilus
    opencloud-desktop
    openscad
    prusa-slicer
    #qbittorrent
    signal-desktop
    thunderbird
    #vlc
    vscodium

    # move that at a better place
    blueberry

    
  # ] ++ lists.optionals (system == 'x86_64-linux') [
    anytype
  ];
}
