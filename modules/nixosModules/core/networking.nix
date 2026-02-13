###############################################################################
#
# Networking basic config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    options.nouveauxParadigmes.hostname = lib.mkOption {
      type        = lib.types.str;
      default     = "unnamedhost";
      description = "What is the host's name? Defaults to unnamedhost.";
    };
  
    config = {
      networking = {
        hostName = cfg.hostname;
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

