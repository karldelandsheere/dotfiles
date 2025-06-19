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
    cmatrix # like the cool guys
    fastfetch
    hugo
    moc
    scooter
  ];

  programs.yt-dlp.enable = true;
}
