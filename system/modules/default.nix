###############################################################################
#
# Shared config for all systems. To be refined.
# 
###############################################################################

{ ... }:
{
  imports = [
    ./filesystem.nix         # Volumes, swap, impermanence, and hibernation
    ./power-management.nix   # Power, hibernation, ...
    ./programs.nix           # Programs that should be by default on all hosts
    ./xdg.nix                # XDG (desktop environment)
  ];
}
