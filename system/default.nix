{ config, lib, pkgs, ... }:
{
  imports = [
    ./users
    ./modules
  ];


  # Set system wide options
  # -----------------------
  options = {
    dotfiles = lib.mkOption {
      description = "Path to NixOS dotfiles, defaults to /etc/nixos";
      type = lib.types.str;
      default = "/etc/nixos";
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
