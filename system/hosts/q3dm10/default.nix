###############################################################################
#
# Custom config for q3dm10 (yeah, like "The Nameless Place" in Quake 3 Arena).
#
# This is an XMG Evo 14 laptop with a AMD Ryzen 7 8845HS and Radeon 780M,
#   96GB DDR5 5600Mhz, and 2TB NVMe.
# 
###############################################################################

{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];

  config = {
    # Custom options
    # --------------
    nouveauxParadigmes = {
      hostname            = "q3dm10";
      cpuFlavor           = "amd";
      rootDisk            = "/dev/nvme0n1";
      swapSize            = 96*1024;
      encryption.enable   = true;
      impermanence.enable = true;
      hibernation = {
        enable = true;
        resume.offset = "1108328";
      };
    };


    # Host specific packages
    # ----------------------
    environment.systemPackages = with pkgs; [
      # ...
    ];
  };
}

