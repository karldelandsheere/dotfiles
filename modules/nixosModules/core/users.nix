###############################################################################
#
# Users' related config. Like defining the host's main user,
#   loading users' config, etc.
#
# Specific users' config/preferences are still stored under ./users (so far).
#
# This loads the host's users config files.
#
# `users` was defined in the flake as an optional list of users which is merged
#   with a common user present on every host: me, aka "unnamedplayer".
#   But since I'm moving into a dendritic model, I'm not sure how I should
#   write that.
#
# This is the less redundant and the most minimal way I found as we can't
#   define imports based on config.${namespace}.something.
#
###############################################################################

{ inputs, self, ... }:
{
  config = {
    flake.nixosModules.core = { lib, config, ...}: let
      cfg = config.nouveauxParadigmes;
      users = [ "unnamedplayer" ];
    in
    {
      imports = lib.forEach users ( username: import ../../../users/${username} );

    };
  };
}
