{ config, pkgs, ... }:
{
  imports = [
    # ./element
    ./firefox.nix
    ./ghostty
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
      # signal-desktop # broken for the moment
      # thunderbird
      # vlc
      # vscodium

    # ] ++ lists.optionals (system == 'x86_64-linux') [
      # anytype
    ];
  };
}
