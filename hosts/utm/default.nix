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


      # That's me
      # ---------
      users.users.unnamedplayer = {
        description = "unnamedplayer";
        createHome = true;
        home = "/home/unnamedplayer";
        group = "users" ;
        extraGroups = [ "wheel" "networkmanager" "input" "docker" ];
        uid = 1312;
        isNormalUser = true;
        hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
      };


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

    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        unnamedplayer = import ./users/unnamedplayer flakeContext;
      };
    }
  ];
  system = "aarch64-linux";
}
