{ pkgs, ... }:
{
  imports = [
    ./config
    ./wm/niri
  ];


  # No need for a DM screen to greet me
  # -----------------------------------
  services.xserver.displayManager.startx.enable = true;
  

  # Used to be in my Hyprland config but it's not really tied to it, is it?
  # @TODO has it that I'll move that under something like ./utils or ./programs
  # ---------------------------------------------------------------------------
  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };

  # @todo move this where it belongs
  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    # swaylock-effects
    wlogout
    wl-clipboard
  ];


  programs = {
    fuzzel.enable = true;

    swayidle = {
      enable = true;
    };

    waybar = {
      enable = true;
      systemd.enable = true;
    };
  };


  programs.swaylock = {
    enable = true;
  };
    
  services = {
    mako.enable = true;
  };
}
