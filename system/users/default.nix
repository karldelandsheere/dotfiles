{ config, pkgs, ... }:
{
  config = {
    # That's me
    # ---------
    users.users.unnamedplayer = {
      uid = 1312;
      hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
      isNormalUser = true;
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
