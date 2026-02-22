###############################################################################
#
# Networking basic config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
  in
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

      environment = {
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
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
          } ) ( lib.lists.unique ( users ) ) );
        };

        # Persist systemd services' tmp files
        # systemd.tmpfiles.rules = [
        #   "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
        #   "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
        #   "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
        # ];
      };
    };
  };
}

