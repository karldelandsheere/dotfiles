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

      networking.hostName = "utm";


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
        extraGroups = [ "wheel" "docker" ];
        uid = 1312;
        isNormalUser = true;
        hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
        packages = with pkgs; [];
      };

      system.stateVersion = "25.05";
    };
  };
in

inputs.nixpkgs.lib.nixosSystem {
  modules = [
    impermanence.nixosModules.impermanence
    ../../hardware-configuration.nix
    ../../modules/system
    ../../custom.nix
    nixosModule
  ];
  system = "aarch64-linux";
}
