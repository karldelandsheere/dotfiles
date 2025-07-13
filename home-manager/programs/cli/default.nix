{ config, pkgs, ... }:
{
  # @todo test mpv
  # @todo test fzf

  # CLI programs with config
  # ------------------------
  imports = [
    # ./aerc
    ./bottom
    ./git.nix
    ./helix
    # ./jrnl
    ./moc
    ./yazi
    # ./yt-dlp
    ./zsh.nix
  ];


  config = {
    # CLI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      # bitwarden-cli
      cmatrix # like the cool guys
      exiftool
      fastfetch # yeah, also like the cool guys
      gpu-screen-recorder
      nix-tree
      progress
      scooter
      tree
    ];
  };
}
