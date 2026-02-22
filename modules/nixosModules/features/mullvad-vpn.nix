###############################################################################
#
# Mullvad VPN config.
#
# For host|user specific options, go to host|user's config.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.mullvad-vpn = { lib, config, ... }: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
  in
  {
    config = {
      services.mullvad-vpn.enable = true;

      environment = {
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
          directories = [
            "/etc/mullvad-vpn"
            "/var/cache/mullvad-vpn"
          ];

          users = lib.listToAttrs ( map ( username: {
            name = username; value = {
              directories = [ ".mullvad" ];
            };
          } ) ( lib.lists.unique ( users ) ) );
        };
      };
    };
  };
}
