{ config, osConfig, pkgs, lib, inputs, ... }:
{
  # GUI programs with config
  # ------------------------
  imports = [
    ./firefox    # @todo Should I move to something else?

    # Day to day
    # ./element # replaced by ../cli/iamb
    # ./signal # replaced by ../cli/gurk

    # Office
    # ./onlyoffice.nix

  ] ++ lib.lists.optionals ( osConfig.nixpkgs.config.allowUnfree ) [
    # Unfree apps :/
    # --------------
    ./obsidian   # Markdown note taking app, @todo should I move to something else?
  ];


  config = {
    # GUI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      bambu-studio           # Slicer for my Bambu printers
      bitwarden-desktop      # Passwords & stuff
      # blender
      openscad               # Code based CAD
      prusa-slicer           # Slicer for my Prusa printers
      # vlc                  # Replaced by mpv (tty video player)
      vscodium               # Code editor
      
      # mullvad-browser
          
      # Day to day
      # opencloud-desktop

      # Utils
      # qbittorrent

      
      # 3d design && 3d printing
      
      # Graphic design
      # Not working on 20250725, try again later if no good alternative found 
      # inputs.affinity-nix.packages.x86_64-linux.designer
      # inputs.affinity-nix.packages.x86_64-linux.photo
      # inputs.affinity-nix.packages.x86_64-linux.publisher

      # Media

      # Screensharing, but can't get it to work so far
      # grim
      # slurp
    ];


    programs = {
      # Nice terminal emulator with gpu acceleration
      # @todo add a check wether gpu acceleration is enabled or not
      ghostty = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
