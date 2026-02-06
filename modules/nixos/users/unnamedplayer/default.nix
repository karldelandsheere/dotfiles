###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
  homeDirectory = "/home/${username}";
in
{
  flake.nixosModules.${username} = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      users.users.${username} = {
        uid = 1312;
        name = username;
        home = homeDirectory;
        
        extraGroups = [ "wheel" "audio" "input" "networkmanager" "plugdev" "video" ];
        hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
        isNormalUser = true;
      };

      home-manager.users.${username} = {
        imports = [ self.homeModules.${username} ];
        
        home = {
          username = username;
          homeDirectory = homeDirectory;
        };
      };
    };
  };

  flake.homeModules.${username} = import ../../../../users/unnamedplayer/modules/home-manager.nix;
}
