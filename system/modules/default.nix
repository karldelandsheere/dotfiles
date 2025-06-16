{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./impermanence.nix
    # ./luks.nix
    ./networking.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./swapfile.nix
  ];
}
