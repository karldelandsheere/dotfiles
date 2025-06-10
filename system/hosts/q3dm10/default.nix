{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];


  # I'm not on a Qwerty, OK?
  # ------------------------
  console.keyMap = "be-latin1";
  # services.xserver.xkb = {
    # layout = "be";
    # variant = "nodeadkeys";
  # };


  # Networking stuff
  # ----------------
  networking = {
    hostName = "q3dm10";
    firewall.enable = true;
  };


  # NixOS version
  # -------------
  system.stateVersion = "25.05";
}

