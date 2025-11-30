{ config, osConfig, pkgs, ... }: let
in
{
  imports = [
    ./niri
    ./noctalia
  ];

  config = {
    home = {
      packages = with pkgs; [
        # nemo
        # qt5.qtwayland
        # qt6.qtwayland
        xwayland-satellite
      ];
    };
  };
}
