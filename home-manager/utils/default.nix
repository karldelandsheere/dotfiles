{ pkgs, ... }:
{
  # Utils with specific config files
  # --------------------------------
  imports = [
    ./fuzzel
    ./mako
    ./swayidle
    ./swaylock
    ./waybar
    ./wlogout
  ];

  # Simple packages
  # ---------------
  home.packages = with pkgs; [
    swaybg
  ];
}
