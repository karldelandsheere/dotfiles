{ config, osConfig, pkgs, lib, inputs, ... }:
{
  # GUI programs with config
  # ------------------------
  imports = [
    ./librewolf              # Fork of Firefox, privacy and no AI bullshit
  ];


  config = {
    # GUI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home = {
      packages = with pkgs; [
        bambu-studio           # Slicer for my Bambu printers
        bitwarden-desktop      # Passwords & stuff
        # blender
        openscad               # Code based CAD
        prusa-slicer           # Slicer for my Prusa printers
        signal-desktop         # Privacy focused messaging
        vivaldi                # Privacy focused browser
        # vlc                  # Replaced by mpv (tty video player)
        vscodium               # Foss version of VSCode

        # mullvad-browser
    
        # Day to day
        # opencloud-desktop

        # Utils
        # qbittorrent

      ] ++ lib.lists.optionals ( osConfig.nixpkgs.config.allowUnfree ) [
        obsidian               # Markdown note taking app
        termius                # Cross-platform SSH client
      
        # Graphic design
        # Not working on 20250725, try again later if no good alternative found 
        # inputs.affinity-nix.packages.x86_64-linux.designer
        # inputs.affinity-nix.packages.x86_64-linux.photo
        # inputs.affinity-nix.packages.x86_64-linux.publisher
      ];

      sessionVariables = {
        BROWSER = "${pkgs.vivaldi}/bin/vivaldi";
      };
    };


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
