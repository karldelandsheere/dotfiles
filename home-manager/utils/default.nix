{ config, pkgs, ... }:
{
  # Utils with specific config files
  # --------------------------------
  imports = [
    ./fuzzel
    ./mako
    ./swayidle
    ./swaylock
    ./waybar
  ];

  config = {
    # Simple packages
    # ---------------
    home.packages = with pkgs; [
      networkmanagerapplet
      swaybg
    ];
  };
}
