{ pkgs, ... }:
{
  # Setting up hibernation
  # https://nixos.wiki/wiki/Hibernation
  # -----------------------------------

  # Set up the swapfile, should be the size of RAM
  # ----------------------------------------------
  swapDevices = [ {
    device = "/swap/swapfile";
    size = 96*1024;
  } ];

  boot = {
    kernelParams = [ "resume_offset=6300928" ];
    resumeDevice = "/dev/disk/by-uuid/46aa91ff-95fb-4bf7-91bd-828ca14115be";
  };
}
