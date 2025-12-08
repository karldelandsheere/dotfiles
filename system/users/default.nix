###############################################################################
#
# Users' stuff.
#
# So far, I'm the sole user, so yeah this file is going to be small.
# But when I'll start setting up for more users, I'll move that into
# a one file per user organization.
# 
###############################################################################

{ config, pkgs, ... }:
{
  config = {
    # That's me
    # ---------
    users.users.unnamedplayer = {
      uid = 1312;
      isNormalUser = true;
      hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
      # passwordFile = config.age.secrets.q3dm10.path;
      # passwordFile = config.age.secrets.unnamedplayer.path;
      extraGroups = [
        "wheel"

        "audio"
        "input"
        "networkmanager"
        "plugdev" # What's that again?
        "video"
      ];
    };
  };
}
