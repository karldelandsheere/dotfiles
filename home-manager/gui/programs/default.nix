{ config, pkgs, inputs, ... }:
{
  # GUI programs with config
  # ------------------------
  imports = [
    ./firefox    # @todo Should I move to something else?
    ./ghostty    # Terminal
    ./obsidian   # Markdown note taking app, @todo should I move to something else?


    # Day to day
    # ./element # replaced by ../cli/iamb
    # ./signal # replaced by ../cli/gurk

    # Utils

    # Office
    # ./onlyoffice.nix
  ];


  config = {
    # GUI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      bitwarden-desktop # Passwords & stuff
      
      # mullvad-browser
          
      # Day to day
      # anytype
      # opencloud-desktop

      # Utils
      # qbittorrent

      # Dev
      # vscodium
      
      # 3d design && 3d printing
      # bambu-studio # crashes, don't know why
      # blender
      # openscad
      # orca-slicer
      # prusa-slicer
      
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
