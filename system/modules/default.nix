{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./impermanence.nix
    # ./luks.nix
    ./networking.nix
    ./power.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./swapfile.nix
  ];


  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d --keep-generations 25";
  #   randomizedDelaySec = "1 hour";
  # };
}
