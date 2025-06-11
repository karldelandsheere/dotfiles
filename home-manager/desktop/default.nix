{ pkgs, ... }:
{
  imports = [
    ./config
    ./wm/niri
  ];

  # Used to be in my Hyprland config but it's not really tied to it, is it?
  # @TODO has it that I'll move that under something like ./utils or ./programs
  # ---------------------------------------------------------------------------
  xdg.portal.xdgOpenUsePortal = true;

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };


  programs = {
    fuzzel.enable = true;

    waybar = {
      enable = true;
      systemd.enable = true;
    };
  };


  services = {
    mako.enable = true;
  };
}
