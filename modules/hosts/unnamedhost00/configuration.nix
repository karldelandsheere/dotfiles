###############################################################################
#
# Config for unnamedhost00.
#
# This is a 2020 M1 MacBook Pro with 16GB of RAM, and 2TB of storage.
#
# Single user host.
#
###############################################################################

{ inputs, self, ... }:
{
  flake = {
    darwinConfigurations.unnamedhost00 = inputs.nixpkgs.lib.darwinSystem {
      modules = [
        self.darwinModules.core

        self.darwinModules.hostUnnamedhost00
      ];
    };

    darwinModules.hostUnnamedhost00 = { config, ... }:
    {
      imports = [
        self.darwinModules.unnamedplayer
      ];

      config = {
        core.mainUser = "karldelandsheere";
        filesystem.dotfiles = "/Users/karldelandsheere/.config/nix-darwin";
      };
    };
  };
}
