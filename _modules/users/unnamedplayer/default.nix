{ inputs, ... }@flakeContext:
let
  homeModule = { config, lib, pkgs, ... }: {
    imports = [
      ./modules.nix
      ./config.nix
    ];
    
    config = {

      # ---- First things first
      programs.home-manager.enable = true;

      home = {
        username = "unnamedplayer";
        homeDirectory = /home/unnamedplayer;
        packages = with pkgs; [
          #vlc
          #qbittorrent
          
          # 3d
          openscad
          prusa-slicer
          
          # webdev
          # hugo

          # utils
          bitwarden
          nautilus

          # Notes
          anytype

          # communication
          thunderbird
          signal-desktop

          # like the cool guys
          cmatrix
          fastfetch
        ];

        stateVersion = "25.05";
      };
    };
  };
  nixosModule = { ... }: {
    home-manager.users.unnamedplayer = homeModule;
  };
in
(
  (
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [ homeModule ];
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
      # extraSpecialArgs = { inherit dotfiles; };
    }
  ) // { inherit nixosModule; }
)
