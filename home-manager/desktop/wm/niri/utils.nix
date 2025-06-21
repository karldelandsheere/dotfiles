{ pkgs, ... }:
{
  # Utils with specific config files
  # --------------------------------
  imports = [
    ../../utils/fuzzel
    ../../utils/mako
    ../../utils/swayidle
    ../../utils/swaylock
    ../../utils/waybar
    ../../utils/wlogout
  ];

  # Simple packages
  # ---------------
  home.packages = with pkgs; [
    swaybg
  ];
}
