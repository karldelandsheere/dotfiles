###############################################################################
#
# This is the common part for all systems config.
#
# The system-wide options and their default values are defined here,
# as the parts that are too small for having their own files.
#
###############################################################################

{ config, lib, pkgs, ... }: let
  cfg = config.nouveauxParadigmes;
  users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
in
{
  # Set system wide options
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


  # These are too small on their own for dedicated files
  # ----------------------------------------------------
  config = {
    services = {
      dbus.implementation = "broker";

      xserver = {
        enable = true;
        displayManager.startx.enable = true;
        xkb.layout = cfg.kbLayout;
      };

      # If the whole system is encrypted and password protected at boot,
      # and there's only one user, no need to type a second login right after
      getty = lib.mkIf ( cfg.encryption.enable && lib.length users == 1 ) {
        autologinUser = "${lib.head users}";
      };
    };
    
    # Console
    console = {
      useXkbConfig = true;
      earlySetup = true;
      font = "Lat2-Terminus16";
    };

    hardware.enableAllFirmware = true; # @todo Is it really required for me?
    services.udisks2.enable = true; # DBus service that allows applications to query and manipulate storage devices

    # Internationalization
    i18n = {
      defaultLocale = "en_US.UTF-8";   # @todo Make it an option maybe?
      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };   

    # Fonts
    fonts.packages = with pkgs; [
      font-awesome
      nerd-fonts.jetbrains-mono
    ];
  };
}
