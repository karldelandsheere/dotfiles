{ inputs, ... }:
{
  imports = [
    ./config
  ];

  # ---- Wayland, XDG, Hyprland, GTK, ...
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };

  programs = {
    hyprlock.enable = true;
  };


  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
  };
}
