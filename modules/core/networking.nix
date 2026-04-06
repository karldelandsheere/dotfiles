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

      # Ressources to persist
      features.impermanence.persist = {
        directories = lib.forEach [
          "NetworkManager/system-connections"
          "ssh"
        ] (x: "/etc/${x}");

        files = lib.forEach [
          "secret_key"
          "seen-bssids"
          "timestamps"
        ] (x: "/var/lib/NetworkManager/${x}");

        users = lib.listToAttrs ( map ( username: {
          name = username; value = {
            directories = [ ".ssh" ];
          };
        } ) ( lib.lists.unique ( config.core.users ) ) );
      };
    };
  };
}

