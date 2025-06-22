{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./helix
    ./moc
    ./yazi.nix
    ./zsh.nix
  ];

  # Other CLI tools
  # ---------------
  home.packages = with pkgs; [
    # audacious # make it look like winamp
    # bitwarden-cli
    cmatrix # like the cool guys
    exiftool
    fastfetch
    hugo
    scooter
  ];

  # programs.aerc.enable = true;
  # programs.aerc.extraConfig.general.unsafe-accounts-conf = true;
  
  programs.yt-dlp.enable = true;
}
