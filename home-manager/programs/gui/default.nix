{ config, pkgs, inputs, ... }:
{
  # GUI programs with config
  # ------------------------
  imports = [
    # Day to day
    # ./element # replaced by ../cli/iamb
    ./firefox
    ./obsidian
    # ./signal # replaced by ../cli/gurk

    # Utils
    ./ghostty

    # Office
    # ./onlyoffice.nix
  ];


  config = {
    # GUI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      # Secrets && privacy
      bitwarden-desktop
      # mullvad-browser
          
      # Day to day
      # anytype
      # opencloud-desktop

      # Utils
      qbittorrent

      # Dev
      vscodium
      
      # 3d design && 3d printing
      # bambu-studio # crashes, don't know why
      blender
      openscad
      # orca-slicer
      prusa-slicer
      
      # Graphic design
      # Not working on 20250725, try again later if no good alternative found 
      # inputs.affinity-nix.packages.x86_64-linux.designer
      # inputs.affinity-nix.packages.x86_64-linux.photo
      # inputs.affinity-nix.packages.x86_64-linux.publisher

      # Media
      # vlc

      # Screensharing, but can't get it to work so far
      # grim
      # slurp
    ];
  };
}
