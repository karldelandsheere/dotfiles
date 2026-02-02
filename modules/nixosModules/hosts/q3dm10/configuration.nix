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

    nixosModules.hostQ3dm10 = { config, ... }: let
      cfg = config.nouveauxParadigmes;
    in
    {
      imports = [
        self.nixosModules.core

        self.nixosModules.features_audio
        self.nixosModules.features_bluetooth
        self.nixosModules.features_graphics

        self.nixosModules.extra_encryption   # Root encryption with LUKS
        self.nixosModules.extra_home-manager # Home-manager setup (not users' config)
        self.nixosModules.extra_impermanence # Stateless system that cleans itself at reboot
        self.nixosModules.extra_tailscale

        ../../../../system
      ];

      config = {
        # Custom options
        # --------------
        nouveauxParadigmes = {
          hostname            = "q3dm10";
          cpuFlavor           = "amd";
          rootDisk            = "/dev/nvme0n1";
          swapSize            = 96*1024;
          encryption.enable   = true;
          impermanence.enable = true;
          hibernation         = {
            enable        = true;
            resume.offset = "1108328";
          };
        };

        hardware.cpu.amd.updateMicrocode = true;

        services.mullvad-vpn.enable = true;
      };
    };
  };
}
