{ inputs, ... }@flakeContext:
let
  nixosModule = { lib, pkgs, ... }: {
    config = {

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
        wireless.enable = false; # no need on a VM
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

      system.stateVersion = "25.05";
    };
  };
in

inputs.nixpkgs.lib.nixosSystem {
  modules = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware-configuration.nix
    ../../modules/system
    nixosModule
  ];
  system = "aarch64-linux";
}
