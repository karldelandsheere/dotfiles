{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./impermanence.nix
    # ./luks.nix
    ./networking.nix
    ./power.nix # also contains hibernation and swapfile config
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
