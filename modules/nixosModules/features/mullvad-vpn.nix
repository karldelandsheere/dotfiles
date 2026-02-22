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

      features.impermanence.persist.directories = [
        "/etc/mullvad-vpn"
        "/var/cache/mullvad-vpn"
      ];

      environment = { # @todo Re-write this to fit the new way
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
          users = lib.listToAttrs ( map ( username: {
            name = username; value = {
              directories = [ ".mullvad" ];
            };
          } ) ( lib.lists.unique ( config.core.users ) ) );
        };
      };
    };
  };
}
