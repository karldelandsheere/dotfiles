{ config, ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./filesystem.nix
    ./impermanence.nix
    # ./luks.nix
    ./networking.nix
    ./power.nix # also contains hibernation and swapfile config
    ./programs.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./stylix.nix
  ];


  config = {
    # Do some cleanup
    # ---------------
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d --keep-generations 25";
        randomizedDelaySec = "1 hour";
      };
      optimise.automatic = true;
      settings.auto-optimise-store = true;
    };
  };
}
