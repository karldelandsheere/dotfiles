{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
  ];


  # I'm not on a Qwerty, OK?
  # ----
  console.keyMap = "be-latin1";
  services.xserver.xkb = {
    layout = "be";
    variant = "nodeadkeys";
  };


  # This is really context related, isn't?
  # --------------------------------------
  networking = {
    hostName = "utm";
    wireless.enable = false;
    firewall.enable = false;
  };


  # System-wide packages
  # --------------------
  environment.systemPackages = with pkgs; [
    curl
    git
    helix
    nano
  ];


  # I like zsh better
  # -----------------
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;


  # NixOS version
  # -------------
  system.stateVersion = "25.05";
}

