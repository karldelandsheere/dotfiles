{ pkgs, inputs, ... }:

{
  # ---- Wayland, XDG, Hyprland, GTK, ...
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };
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
    hyprlock.enable = true;

    waybar = {
      enable = true;
      systemd.enable = true;
    };
  };


  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
    mako.enable = true;
  };


  # home.sessionVariables = {
  # };
}
