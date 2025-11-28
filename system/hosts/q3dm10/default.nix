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

