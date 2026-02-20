###############################################################################
#
# Config for q3dm10 (yeah, like "The Nameless Place" in Quake 3 Arena).
#
# This is an XMG Evo 14 laptop with a AMD Ryzen 7 8845HS and Radeon 780M,
#   96GB DDR5 5600Mhz, and 2TB NVMe.
#
# Single user host.
#
###############################################################################

{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.q3dm10 = inputs.nixpkgs.lib.nixosSystem {
      modules = [ self.nixosModules.hostQ3dm10 ];
    };

    nixosModules.hostQ3dm10 = { config, ... }:
    {
      imports = [
        self.nixosModules.core
        self.nixosModules.tailscale

        self.nixosModules.encryption
        self.nixosModules.impermanence
        self.nixosModules.powersave
        self.nixosModules.hibernation

        self.nixosModules.audio
        self.nixosModules.bluetooth
        self.nixosModules.graphics

        self.nixosModules.desktop

        # AMD specific options
        self.nixosModules.core_amd
        self.nixosModules.powersave_amd

        # User(s)
        self.nixosModules.unnamedplayer
      ];

      config = {
        # Preferences
        # -----------
        networking.hostName = "q3dm10";

        features.hibernation.resumeOffset = "1108328";
        filesystem.swapSize = 96*1024;

        time.timeZone = "Europe/Brussels";

        nixpkgs.config.allowUnfree = true;
        system.stateVersion = "25.11";

        services = {
          mullvad-vpn.enable = true;
          xserver.xkb.layout = "be";
        };
      };
    };
  };
}
