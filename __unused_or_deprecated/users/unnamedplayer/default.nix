###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ config, pkgs, lib, inputs, ... }: let
  username = "unnamedplayer";
in
{
  # User registration at system level
  config = {
    home-manager.users.${username} = {
      home = {
        username      = "${username}";
        homeDirectory = lib.mkDefault "/home/${username}"; # This will go into "default"
        # homeDirectory = lib.mkDefault "/home/${config.home.username}"; # This will go into "default"
      };
      
      imports = [ ./modules/home-manager.nix ];
    };
  };
}
