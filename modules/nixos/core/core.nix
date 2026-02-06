###############################################################################
#
# Core options that are too small for having their own files.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    options.nouveauxParadigmes = {
      rootDisk = lib.mkOption {
        type        = lib.types.str;
        default     = "";
        description = "Which is the root disk? No default";
      };

      # Inputs
      kbLayout = lib.mkOption {
        type        = lib.types.str;
        default     = "be";
        description = "Keyboard layout. Defaults to be";
      };

      # Dotfiles path
      dotfiles = lib.mkOption {
        type        = lib.types.str;
        default     = "/etc/nixos";
        description = "Path to NixOS dotfiles. Defaults to /etc/nixos";
      };

      # GUI or not
      gui.enable = lib.mkOption {
        type        = lib.types.bool;
        default     = true;
        description = "Enable GUI? Defaults to true.";
      };

      system = lib.mkOption { # @todo Is that used at all?
        type        = lib.types.str;
        default     = "x86_64-linux";
        description = "What is the system architecture? Defaults to x86_64-linux.";
      };

      cpuFlavor = lib.mkOption { # On its way out I guess
        type        = lib.types.str;
        default     = "";
        description = "amd or intel?";
      };
    };
  
    config = {
      console = {
        earlySetup = true;
        font = "Lat2-Terminus16";
        useXkbConfig = true;
      };

      fonts.packages = with pkgs; [
        font-awesome
        nerd-fonts.jetbrains-mono
      ];
      
      hardware.enableAllFirmware = true; # Is it really required for me

      i18n = {
        defaultLocale = "en_US.UTF-8";
        inputMethod = {
          enable = true;
          type = "ibus";
        };
      };

      services = {
        dbus.implementation = "broker";
        udisks2.enable = true; # DBus service that allows apps to query/manipulate storage devices
        xserver.xkb.layout = cfg.kbLayout;
      };
    };
  };
}

