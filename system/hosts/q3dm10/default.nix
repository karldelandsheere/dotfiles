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


    # Networking stuff
    # ----------------
    networking.hostName = "q3dm10";


    # NixOS version
    # -------------
    system.stateVersion = "25.05";
  };
}

