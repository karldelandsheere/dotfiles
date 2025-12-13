###############################################################################
#
# Custom config for an UTM virtual machine hosted on a MacBook Pro M1.
#
###############################################################################

{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/default.nix
  ];

  config = {
    # Custom options
    # --------------
    nouveauxParadigmes = {
      hostname            = "utm";
      system              = "aarch64-linux";
      rootDisk            = "/dev/vda";
      impermanence.enable = true;
    };
  };


  # Qemu/UTM specific packages
  # --------------------------
  environment.systemPackages = with pkgs; [
    # ...
  ];


  # It's a VM so no need for that
  # -----------------------------
  networking.wireless.enable = false;
}

