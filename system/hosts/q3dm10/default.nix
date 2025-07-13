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
      rootDisk            = "/dev/nvme0n1";
      swapSize            = "96G";
      encryption.enable   = true;
      impermanence.enable = true;
    };


    # AMD specific packages
    # ---------------------
    environment.systemPackages = with pkgs; [
      microcode-amd
    ];
  };
}

