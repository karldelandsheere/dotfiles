{ config, lib, pkgs, ... }:
{
  imports = [
    ./users
    ./modules
  ];


  # Set system wide options
  # -----------------------
  options.nouveauxParadigmes = {
    hostname = lib.mkOption {
      type        = lib.types.str;
      default     = "unnamedhost";
      description = "What is the host's name? Defaults to unnamedhost.";
    };
    
    system = lib.mkOption {
      type        = lib.types.str;
      default     = "x86_64-linux";
      description = "What is the system architecture? Defaults to x86_64-linux.";
    };
    
    rootDisk = lib.mkOption {
      type        = lib.types.str;
      default     = "";
      description = "Which is the root disk?";
    };
    
    swapSize = lib.mkOption {
      type        = lib.types.str;
      default     = "8G";
      description = "Size of swapfile. Defaults to 8G.";
    };

    encryption.enable   = lib.mkEnableOption "Use full disk encryption? Defaults to false.";
    impermanence.enable = lib.mkEnableOption "Use impermanence? Defaults to false.";

    homeManager.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Use Home-Manager? Defaults to true.";
    };

    gui.enable = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Enable GUI? Defaults to true.";
    };

    dotfiles = lib.mkOption {
      type        = lib.types.str;
      default     = "/etc/nixos";
      description = "Path to NixOS dotfiles. Defaults to /etc/nixos";
    };

    kbLayout = lib.mkOption {
      type        = lib.types.str;
      default     = "be";
      description = "Keyboard layout. Defaults to be";
    };

    nixosVersion = lib.mkOption {
      type        = lib.types.str;
      default     = "25.05";
      description = "NixOS state version. Defaults to 25.05";
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


    # NixOS version
    # -------------
    system.stateVersion = "25.05";
  };
}
