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
    # ./wlogout # if not used in a couple of weeks, remove it completely
  ];

  # Simple packages
  # ---------------
  home.packages = with pkgs; [
    swaybg
  ];
}
