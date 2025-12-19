###############################################################################
#
# Users' stuff.
#
###############################################################################

{ config, pkgs, ... }: let
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
    users = lib.genAttrs allUsers ( username: {
      # name = username;
      # home = "/home/${username}";
  
      imports = [ ../../users/${username} ];
    } );


    # If home-manager is enabled, import users' config for it
    home-manager = lib.mkIf cfg.homeManager.enable {
      # Import all user specific config
      users = lib.genAttrs allUsers ( username: {
        imports = [ ../../users/${username}/home-manager.nix ];
      } );
    };
    





    
    # # That's me
    # # ---------
    # users.users.unnamedplayer = {
    #   uid = 1312;
    #   isNormalUser = true;
    #   hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
    #   # passwordFile = config.age.secrets.q3dm10.path;
    #   # passwordFile = config.age.secrets.unnamedplayer.path;
    #   extraGroups = [
    #     "wheel"
    #     "audio"
    #     "input"
    #     "networkmanager"
    #     "plugdev" # What's that again?
    #     "video"
    #   ];
    # };
  };
}
