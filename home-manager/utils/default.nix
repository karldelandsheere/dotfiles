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


    # Automount USB storage drives
    # https://wiki.nixos.org/wiki/USB_storage_devices
    # -----------------------------------------------
    services.udiskie = {
      enable = true;
      # systemdTarget = "niri-session.target";
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        };
      };
    };
  };
}
