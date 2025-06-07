{ pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hyprland.nix
    ./impermanence.nix
    # ./luks.nix
    ./swapfile.nix
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


  # Time settings (too small for a dedicated file)
  # -------------
  time.timeZone = "Europe/Brussels";


  # Foots (too small for a dedicated file)
  # -----
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];


  # Hardware (too small for a dedicated file)
  # --------
  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };


  # Git is needed for at least maintaining these dotfiles
  # -----------------------------------------------------
  programs.git.enable = true;


  # No need to change that stuff
  # ----------------------------
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ]; # Activate flakes
    trusted-users = [ "@wheel" ]; # wheel group gets trusted access to nix daemon
    warn-dirty = false;
  };

  nixpkgs.config.allowUnfree = true; # At least for now
}
