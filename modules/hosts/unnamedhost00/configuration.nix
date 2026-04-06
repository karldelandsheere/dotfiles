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
    darwinConfigurations.unnamedhost00 = inputs.darwin.lib.darwinSystem {
      modules = with self.modules.darwin; [
        core

        hostUnnamedhost00
      ];
    };

    modules.darwin.hostUnnamedhost00 = { config, ... }:
    {
      imports = with self.modules.darwin; [
        # User(s)
        karldelandsheere
      ];

      config = {
        core.mainUser = "karldelandsheere";
        filesystem.dotfiles = "/Users/karldelandsheere/.config/nix-darwin";
      };
    };
  };
}
