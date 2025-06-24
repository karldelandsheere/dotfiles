{ config, pkgs, ... }:
{
  imports = [
    # ./element
    ./firefox.nix
    ./terminal.nix
  # ] ++ lists.optionals (system == 'x86_64-linux') [
    # ./onlyoffice.nix
  ];

  home = {
    packages = with pkgs; [
      # bambu-studio
      bitwarden
      # blender
      # nautilus
      opencloud-desktop
      # openscad
      # orca-slicer
      # prusa-slicer
      #qbittorrent
      # signal-desktop
      # thunderbird
      #vlc
      # vscodium

    # ] ++ lists.optionals (system == 'x86_64-linux') [
      # anytype
    ];
  };
}
