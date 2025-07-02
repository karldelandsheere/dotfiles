{ pkgs, ... }:
{
  # CLI tools with configurations
  # -----------------------------
  imports = [
    ./aerc
    ./bottom
    ./git.nix
    ./helix
    ./jrnl
    ./moc
    ./yazi
    ./yt-dlp
    ./zsh.nix
  ];

  # CLI tools that either don't need config or are on trial
  # -------------------------------------------------------
  home.packages = with pkgs; [
    # audacious # make it look like winamp
    bitwarden-cli
    cmatrix # like the cool guys
    exiftool
    fastfetch
    # hugo
    scooter
  ];
}
