{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];

  config = {
    # I'm not on a Qwerty, OK?
    # ------------------------
    services.xserver.xkb.layout = "be";


    # AMD specific packages
    # ---------------------
    environment.systemPackages = with pkgs; [
      microcode-amd
    ];


    # Swap file
    # ---------
    swapDevices = [ {
      device = "/swap/swapfile";
      size   = 96*1024; # Should be at least the size of the RAM (hibernation)
    } ];


    # Networking stuff
    # ----------------
    networking.hostName = "q3dm10";


    # NixOS version
    # -------------
    system.stateVersion = "25.05";
  };
}

