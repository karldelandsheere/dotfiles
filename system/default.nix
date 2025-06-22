{ config, lib, pkgs, ... }:
{
  imports = [
    ./users
    ./programs
    ./modules
  ];


  options.unnamedplayer = {
    # Nix system
    # ----------
    system = lib.mkOption {
      type = lib.types.str;
      description = "x86_64-linux || aarch64-linux";
      default = "x86_64-linux";
    };
  };


  config = {
    # Console
    # -------
    console = {
      useXkbConfig = true;
      earlySetup = true;
      font = "Lat2-Terminus16";
    };


    # Hardware (too small for a dedicated file)
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


    # Fonts (too small for a dedicated file)
    # -----
    fonts.packages = with pkgs; [
      font-awesome
      nerd-fonts.jetbrains-mono
    ];
  };
}
