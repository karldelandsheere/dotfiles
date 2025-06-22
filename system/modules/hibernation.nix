{ pkgs, ... }:
{
  # Setting up hibernation
  # https://nixos.wiki/wiki/Hibernation
  # -----------------------------------

  # Set up the swapfile, should be the size of RAM
  # ----------------------------------------------
  swapDevices = [ {
    device = "/var/local/swapfile";
    size = 96*1024;
  } ];

  
}
