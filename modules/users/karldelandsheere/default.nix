###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "karldelandsheere";
  homeDirectory = "/Users/${username}";
in
{
  flake.darwinModules.${username} = { lib, config, ... }:
  {
    config = {
      home-manager.users.${username} = {
        imports = [ self.homeModules.${username} ];
        
        home = {
          username = username;
          homeDirectory = homeDirectory;
        };
      };
    };
  };

  flake.homeModules.${username} = { config, pkgs, osConfig, lib, ... }:
  {
    config = {
    };
  };
}
