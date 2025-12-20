###############################################################################
#
# Shared config for all systems. To be refined.
# 
###############################################################################

{ config, lib, inputs, ... }:
  cfg = config.nouveauxParadigmes;
{
  imports = [
    ./boot.nix               # Boot options and GRUB styling
    ./encryption.nix         # Root encryption with LUKS
    ./filesystem.nix         # Volumes, swap, options for impermanence and hibernation
    # ./gui.nix                # GUI (desktop environment)
    ./hardware.nix           # All hardware, bluetooth, graphics, sound, ...
    ./home-manager.nix
    ./impermanence.nix       # Stateless system that cleans itself at reboot
    ./networking.nix         # Networking, SSH, VPN, Tailscale, ...
    ./power-management.nix   # Power, hibernation, ...
    ./programs.nix           # Programs that should be by default on all hosts
    ./secrets.nix
    ./security.nix
    ./users.nix
    ./xdg.nix
  ];


  # Related options and default values definition
  options.nouveauxParadigmes = {
    stateVersion = lib.mkOption {
      type        = lib.types.str;
      default     = "25.11";
      description = "NixOS' state version. Defaults to 25.11";
    };

    # Philosophical and pragramtic question...
    allowUnfree = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Allow unfree software to be installed? Defaults to true";
    };
  };


  config = {
    # NixOS version
    system.stateVersion = cfg.stateVersion;


    # Nix options
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ]; # Activate flakes, etc.
        trusted-users = [ "@wheel" ];
        warn-dirty = false; # For some reason, it still does...
      };

      # Do some cleanup
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d --keep-generations 25";
        randomizedDelaySec = "1 hour";
      };
      optimise.automatic = true;
      settings.auto-optimise-store = true;
    };


    nixpkgs.config.allowUnfree = cfg.allowUnfree;     # Allow unfree software?
  };
}
