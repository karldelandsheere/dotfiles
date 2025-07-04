{ config, pkgs, ... }:
{
  # @todo test cinny-desktop instead of element

  # GUI programs with config
  # ------------------------
  imports = [
    # ./element
    ./firefox.nix
    ./ghostty
    ./signal
    # ./onlyoffice.nix
  ];


  config = {
    # GUI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      # anytype
      # bambu-studio # crashes, don't know why
      bitwarden
      # blender
      # grim
      opencloud-desktop
      # openscad
      # orca-slicer
      # prusa-slicer
      # qbittorrent
      # slurp
      vlc
      # vscodium
    ];
  };
}
