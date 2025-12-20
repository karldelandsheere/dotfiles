###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ config, pkgs, ... }:
{
  # User registration at system level
  uid            = 1312;
  isNormalUser   = true;
  hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
  extraGroups    = [ "wheel" "audio" "input" "networkmanager" "plugdev" "video" ];
}
