{ config, pkgs, ... }:
{
  # @todo test fzf

  # CLI programs with config
  # ------------------------
  imports = [
    # Day to day
    ./aerc
    ./calcurse
    ./gurk
    ./iamb
    # ./jrnl

    # Utils
    ./bottom
    ./git.nix
    ./helix
    ./yazi
    ./zsh.nix

    # Media
    ./moc
    ./yt-dlp
  ];


  config = {
    # CLI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      # Secrets
      bitwarden-cli

      # Day to day

      # Utils
      exiftool
      nix-tree
      progress
      scooter
      tree

      # Screen recording but still have to try it out
      gpu-screen-recorder

      # Media
      cava
      ffmpeg
      mpv

      # Like the cool guys
      cmatrix
      fastfetch
    ];
  };
}
