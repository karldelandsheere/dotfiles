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
    console.earlySetup = true;


    # Hardware (too small for a dedicated file)
    # --------
    hardware = {
      bluetooth.enable = true;
      graphics.enable = true;
    };


    # Tailscale
    # ---------
    unnamedplayer.tailscale.enable = true;


    # I speak French, but let's keep it simple
    # ----------------------------------------
    i18n.defaultLocale = "en_US.UTF-8";


    # Time settings
    # -------------
    time.timeZone = "Europe/Brussels";
  };


  # Fonts (too small for a dedicated file)
  # -----
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];


  # Security stuff
  # --------------
  security = {
    # Yeah, read it was better to set that, but honnestly don't know why
    sudo.extraConfig = ''
      Defaults lecture = never
    '';

    polkit.enable = true; # Apparently needed for Hyprland?
  };


  # Some basic services
  # -------------------
  services = {
    dbus.implementation = "broker";

    xserver.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    pulseaudio.enable = false; # For now

    locate.enable = true;
  };
}
