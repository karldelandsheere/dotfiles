###############################################################################
#
# Mullvad VPN config.
#
# For host|user specific options, go to host|user's config.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.mullvad-vpn = { lib, config, ... }:
  {
    config = {
      services.mullvad-vpn.enable = true;

      # Ressources to persist
      features.impermanence.persist = {
        directories = [
          "/etc/mullvad-vpn"
          "/var/cache/mullvad-vpn"
        ];

        users = lib.listToAttrs ( map ( username: {
          name = username; value = {
            directories = [ ".mullvad" ];
          };
        } ) ( lib.lists.unique ( config.core.users ) ) );
      };
    };
  };
}
