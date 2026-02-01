###############################################################################
#
# Shared config for all systems. To be refined.
# 
###############################################################################

{ ... }:
{
  imports = [
    ./boot.nix               # Boot options and GRUB styling
    ./encryption.nix         # Root encryption with LUKS
    ./filesystem.nix         # Volumes, swap, impermanence, and hibernation
    ./hardware.nix           # All hardware, bluetooth, graphics, sound, ...
    ./networking.nix         # Networking, SSH, VPN, Tailscale, ...
    ./power-management.nix   # Power, hibernation, ...
    ./programs.nix           # Programs that should be by default on all hosts
    ./security.nix
    ./xdg.nix                # XDG (desktop environment)
  ];
}
