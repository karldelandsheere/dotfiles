###############################################################################
#
# Networking basic config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}:
  {
    config = {
      networking = {
        networkmanager.enable = true;
        enableIPv6 = true;

        firewall.enable = true;
      };

      services.openssh = {
        enable = true;
        hostKeys = [
          { path = "/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
          { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
        ];
        # openFirewall = false; # for now
        # banner = "";
      };
    };
  };
}

