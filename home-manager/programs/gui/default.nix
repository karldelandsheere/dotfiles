{ config, pkgs, ... }:
{
  # @todo test cinny-desktop instead of element

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
      grim
      kooha
      opencloud-desktop
      # openscad
      # orca-slicer
      # prusa-slicer
      # qbittorrent
      slurp
      # thunderbird
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      # vlc
      # vscodium

    # ] ++ lists.optionals (system == 'x86_64-linux') [
      # anytype
    ];
  };
}
