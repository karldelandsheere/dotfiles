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
    flake.nixosModules.core = { lib, config, ...}:
    {
      core.users = builtins.attrNames (
        lib.filterAttrs ( _: v: ( v.isNormalUser ) )
          config.users.users
      );

      # If impermanence is enabled,
      #   persist the directories and files common to all users
      environment.persistence."/persist" = lib.mkIf config.features.impermanence.enable {
        users = lib.listToAttrs ( map ( username: {
          name = username; value = {
            directories = [
              "Data"  # Vaults, documents, etc
            ];
          };
        } ) ( lib.lists.unique ( config.core.users ) ) );
      };
    };
  };
}
