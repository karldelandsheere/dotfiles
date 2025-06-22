{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./hibernation.nix # also contains swapfile config
    ./impermanence.nix
    # ./luks.nix
    ./networking.nix
    ./power.nix
    ./security.nix
    ./services.nix
    ./sound.nix
  ];


  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d --keep-generations 25";
  #   randomizedDelaySec = "1 hour";
  # };
}
