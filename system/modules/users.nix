###############################################################################
#
# Users' stuff.
#
# Some inspo for writing this:
#   https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/users/default.nix
#
###############################################################################

{ config, pkgs, lib, ... }: let
  cfg = config.nouveauxParadigmes;
  allUsers = lib.lists.unique (
    lib.singleton "${cfg.users.main}"
    ++ lib.lists.optionals (cfg.users.others != []) cfg.users.others );
in
{
  options.nouveauxParadigmes = {
    # System users
    users = {
      main = lib.mkOption {
        type        = lib.types.str;
        default     = "unnamedplayer";
        description = "System's main user. Defaults to unnamedplayer (me)";
      };

      others = lib.mkOption {
        type        = lib.types.listOf lib.types.str;
        default     = [];
        description = "Other users on this system/host. Defaults to []";
      };
    };
  };

  
  config = {
    # Import users' system config
    users.users = ( lib.mergeAttrsList ( map ( username: {
      "${username}" = {
        name = username;
        home = "/home/${username}";
      } // (
        import ../../users/${username} { inherit config pkgs lib; }
      ); } ) allUsers )
    );

    # If home-manager is enabled, import users' config for it
    home-manager = lib.mkIf cfg.homeManager.enable {
      # Import all user specific config
      users = lib.genAttrs allUsers ( username: {
        imports = [ ../../users/${username}/home-manager.nix ];
      } );
    };
  };
}
