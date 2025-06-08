{ ... }:
{
  imports = [
    ./boot.nix
    ./impermanence.nix
    # ./luks.nix
    ./networking.nix
    ./swapfile.nix
  ];
}
