{ config, pkgs, ... }:
{
  imports = [
    ./element
    ./firefox.nix
    ./ghostty
    ./signal
  # ] ++ lists.optionals (system == 'x86_64-linux') [
    # ./onlyoffice.nix
  ];

  home = {
    packages = with pkgs; [
      # bambu-studio # crashes, don't know why
      bitwarden
      # blender
      opencloud-desktop
      # openscad
      # orca-slicer
      # prusa-slicer
      # qbittorrent
      # thunderbird
      # vlc
      # vscodium

    # ] ++ lists.optionals (system == 'x86_64-linux') [
      # anytype
    ];
  };
}
