{ config, pkgs, ... }:
{
  # GUI programs with config
  # ------------------------
  imports = [
    ./firefox
    ./ghostty

    # ./onlyoffice.nix

    # ./element # replaced by ../cli/iamb
    # ./signal # replaced by ../cli/gurk
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
      # mullvad-browser
      # opencloud-desktop
      # openscad
      # orca-slicer
      # prusa-slicer
      qbittorrent
      # slurp
      # vlc
      vscodium
    ];
  };
}
