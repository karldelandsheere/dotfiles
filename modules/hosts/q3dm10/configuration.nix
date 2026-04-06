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
      modules = with self.modules.nixos; [
        core

        mullvad-vpn
        tailscale

        hostQ3dm10
      ];
    };

    modules.nixos.hostQ3dm10 = { config, lib, ... }:
    {
      imports = with self.modules.nixos; [
        audio
        bluetooth
        desktop
        encryption
        graphics
        hibernation
        impermanence
        powersave

        # AMD
        core_amd
        powersave_amd

        # User(s)
        unnamedplayer
      ];

      config = {
        # Preferences
        # -----------
        networking.hostName = "q3dm10";
        features.hibernation.resumeOffset = "1108328";
        filesystem.swapSize = 96*1024;
        services.xserver.xkb.layout = "be";
      };
    };
  };
}
