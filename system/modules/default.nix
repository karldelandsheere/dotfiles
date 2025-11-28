{ config, lib, inputs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./filesystem.nix
    ./home-manager.nix
    ./impermanence.nix
    ./luks.nix
    ./networking.nix
    ./power.nix # also contains hibernation and swapfile config
    ./programs.nix
    ./secrets.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./xdg.nix
  ];


  # Nix and NixOS settings
  # ----------------------
  config = {
    # NixOS version
    # -------------
    system.stateVersion = config.nouveauxParadigmes.stateVersion;


    nix = {
      # Activate flajes, etc.
      # ---------------------
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "@wheel" ];
        warn-dirty = false; # For some reason, it still does...
      };


      # Do some cleanup
      # ---------------
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d --keep-generations 25";
        randomizedDelaySec = "1 hour";
      };
      optimise.automatic = true;
      settings.auto-optimise-store = true;
    };


    # I'd like it to be false, but that's not for today, is it?
    # ---------------------------------------------------------
    nixpkgs.config.allowUnfree = true;
  };
}
