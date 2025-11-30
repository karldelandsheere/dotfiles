{ config, pkgs, ... }:
{
  # @todo test fzf

  # CLI programs with config
  # ------------------------
  imports = [
    # Day to day
    # ./aerc
    # ./calcurse
    # ./gurk
    # ./iamb
    # ./jrnl

    # Utils
    # ./bottom
    ./git.nix
    ./helix
    # ./yazi
    ./zsh.nix

    # Media
    # ./yt-dlp

    # Like the cool kids
    # ./fastfetch
  ];


  config = {
    # CLI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      # Secrets
      bitwarden-cli

      # Day to day
      # basalt @todo check in a couple months where the dev is at

      # Utils
      # exiftool
      # nix-tree
      # progress
      # scooter
      tree

      # Screen recording but still have to try it out
      # gpu-screen-recorder

      # Media
      # ffmpeg
      # mpv
      # termusic # @todo config that

      # Like the cool kids
      # cava
      # cmatrix
    ];
  };
}
