{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./helix.nix
    ./yazi.nix
    ./zsh.nix
  ];

  # Other CLI tools
  # ---------------
  home.packages = with pkgs; [
    # audacious # make it look like winamp
    cmatrix # like the cool guys
    exiftool
    fastfetch
    hugo
    moc
    scooter
  ];

  programs.yt-dlp.enable = true;
}
