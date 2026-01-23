###############################################################################
#
# Impermanence setup
# The idea is to wipe /root at every boot to keep things clean
# except for directories and files declared persistents
# Needs the impermanence flake
#
# Based on so many sources, the latest being
# https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/persist.nix
#
###############################################################################

{ inputs, self, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = {
    flake.nixosModules.impermanence = { config, ... }:
    {

    };
  };
}

