{ config, lib, pkgs, ... }:
{
  imports = [
    ./users
    ./modules
  ];


  # Set system wide options
  # -----------------------
  options.nouveauxParadigmes = {
    rootDisk = lib.mkOption {
      type        = lib.types.str;
      default     = "/dev/nvme0n1";
      description = "Which is the root disk? Defaults to /dev/nvme0n1";
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


    # Time settings
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
