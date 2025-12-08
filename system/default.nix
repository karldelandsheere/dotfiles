###############################################################################
#
# This is the common part for all systems config.
#
# The system-wide options and their default values are defined here,
# as the parts that are too small for having their own files.
#
###############################################################################

{ config, lib, pkgs, ... }:
{
  imports = [
    ./users
    ./modules
  ];


  # Set system wide options
  # -----------------------
  options.nouveauxParadigmes = {
    # Name and networking
    hostname = lib.mkOption {
      type        = lib.types.str;
      default     = "unnamedhost";
      description = "What is the host's name? Defaults to unnamedhost.";
    };

    # System and OS
    system = lib.mkOption {
      type        = lib.types.str;
      default     = "x86_64-linux";
      description = "What is the system architecture? Defaults to x86_64-linux.";
    };

    cpuFlavor = lib.mkOption {
      type        = lib.types.str;
      default     = "";
      description = "amd or intel?";
    };

    stateVersion = lib.mkOption {
      type        = lib.types.str;
      default     = "25.05";
      description = "NixOS state version. Defaults to 25.05";
    };

    # Inputs
    kbLayout = lib.mkOption {
      type        = lib.types.str;
      default     = "be";
      description = "Keyboard layout. Defaults to be";
    };

    # Filesystem
    rootDisk = lib.mkOption {
      type        = lib.types.str;
      default     = "";
      description = "Which is the root disk?";
    };
    
    swapSize = lib.mkOption {
      type        = lib.types.int;
      default     = 8*1024;
      description = "Size of swapfile. Defaults to 8*1024. If hibernation is enabled, it should be at least your RAM size.";
    };

    encryption.enable   = lib.mkEnableOption "Use full disk encryption? Defaults to false.";
    impermanence.enable = lib.mkEnableOption "Use impermanence? Defaults to false.";

    # User preferences
    dotfiles = lib.mkOption {
      type        = lib.types.str;
      default     = "/etc/nixos";
      description = "Path to NixOS dotfiles. Defaults to /etc/nixos";
    };

    gui.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Enable GUI? Defaults to true.";
    };

    homeManager.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Use Home-Manager? Defaults to true.";
    };

    # Philosophical and pragmatical question...
    allowUnfree = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Allow unfree software to be installed? Defaults to true, despite that I'd rather not to.";
    };
  };


  # These are too small on their own for a dedicated file
  # -----------------------------------------------------
  config = {
    # Console
    # -------
    console = {
      useXkbConfig = true;
      earlySetup = true;
      font = "Lat2-Terminus16";
    };


    # System packages
    # ---------------
    environment.systemPackages = [
      # ...
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.cpuFlavor == "amd" ) [
      pkgs.microcode-amd
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.cpuFlavor == "intel" ) [
      pkgs.microcode-intel
    ];


    # Hardware
    # --------
    hardware = {
      enableAllFirmware = true;
      graphics.enable = true;
    };


    # I speak French, but let's keep it simple
    # ----------------------------------------
    i18n.defaultLocale = "en_US.UTF-8";


    # Time settings (let's assume that for now)
    # -------------
    time.timeZone = "Europe/Brussels";


    # Fonts
    # -----
    fonts.packages = with pkgs; [
      font-awesome
      nerd-fonts.jetbrains-mono
    ];
  };
}
