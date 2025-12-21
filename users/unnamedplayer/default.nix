###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ config, pkgs, lib, ... }: let
  username = "unnamedplayer";
in
{
  
  # User registration at system level
  config = {
    users.users."${username}" = {
      name = username;
      home = "/home/${username}";
      uid            = 1312;
      isNormalUser   = true;
      hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
      extraGroups    = [ "wheel" "audio" "input" "networkmanager" "plugdev" "video" ];
    };

    home-manager.users.${username} = {
      imports = [ ../../users/${username}/home-manager.nix ];
    };

    # Additional VPN
    # services.globalprotect = {
    #   enable = true;
    #   settings = {};
    # };
    # systemd.services.globalprotect.wantedBy = lib.mkForce []; # no autostart
  };
}
