###############################################################################
#
# This file loads the host's users config files.
#
# `users` is defined in the flake as an optional list of users which is merged
#   with a common user present on every host: me, aka "unnamedplayer".
#
# This is the less redundant and the most minimal way I found as we can't
#   define imports based on config.${namespace}.something. 
#
###############################################################################

{ lib, users, ... }:
{
  imports = lib.forEach users ( username: import ./${username} );
}
