###############################################################################
#
# This is the common part for all systems config.
#
# The system-wide options and their default values are defined here,
# as the parts that are too small for having their own files.
#
###############################################################################

{ config, lib, pkgs, users, ... }: let
  cfg = config.nouveauxParadigmes;
in
{
  imports = [
    ./modules      # Common config modules
    ../users       # Loads the users specific configs
  ];


  # Set system wide options
  # -----------------------
  options.nouveauxParadigmes = {
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
  };


  # These are too small on their own for a dedicated file
  # -----------------------------------------------------
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
    # -------
    console = {
      useXkbConfig = true;
      earlySetup = true;
      font = "Lat2-Terminus16";
    };


    i18n = {
      defaultLocale = "en_US.UTF-8";   # I speak French, but let's keep it simple
      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };   


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
