###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "karldelandsheere";
in
{
  flake.modules.darwin.${username} = { lib, config, ... }:
  {
    config = {
      home-manager.users.${username} = {
        imports = [ self.homeModules.${username} ];
        
        home = {
          username = username;
          homeDirectory = "/Users/${username}";
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
