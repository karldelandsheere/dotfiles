{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];

  config = {
    gui.enable = false; # full tty on this setup
  
  
    # I'm not on a Qwerty, OK?
    # ------------------------
    services.xserver.xkb.layout = "be";


    # Intel specific packages
    # ---------------------
    environment.systemPackages = with pkgs; [
      microcode-intel
    ];


    # Swap file
    # ---------
    swapDevices = [ {
      device = "/swap/swapfile";
      size   = 8*1024; # Should be at least the size of the RAM (hibernation)
    } ];


    # Networking stuff
    # ----------------
    networking.hostName = "q3dm11";


    # NixOS version
    # -------------
    system.stateVersion = "25.05";
  };
}
