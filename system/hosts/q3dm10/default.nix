{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];


  # I'm not on a Qwerty, OK?
  # ----
  console.keyMap = "be-latin1";
  services.xserver.xkb = {
    layout = "be";
    variant = "nodeadkeys";
  };


  # It's a VM so no need for that, right?
  # -------------------------------------
  networking = {
    hostName = "q3dm10";
    wireless.enable = true;
    firewall.enable = true;
  };


  # NixOS version
  # -------------
  system.stateVersion = "25.05";
}

