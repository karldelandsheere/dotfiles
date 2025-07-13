{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];

  config = {
    # Custom options
    # --------------
    nouveauxParadigmes = {
      hostName = "utm";
      system   = "aarch64-linux";
      rootDisk = "/dev/vda";
      
    };
  };


  # Qemu/UTM specific packages
  # --------------------------
  environment.systemPackages = with pkgs; [
    
  ];


  # It's a VM so no need for that
  # -----------------------------
  networking.wireless.enable = false;
}

