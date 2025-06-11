{ pkgs, ... }:

{
  # No need for a DM screen to greet me
  # -----------------------------------
  services.xserver.displayManager.startx.enable = true;
  
  
  xdg = {
    portal = {
      config = {
        common.default = [ "gtk" ];
        # hyprland.default = [
        #   "gtk"
        #   "hyprland"
        # ];
      };
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };

  
  # programs.hyprland = {
  #   enable = true;
  #   withUWSM = true;
  #   xwayland.enable = true;
  #   portalPackage = pkgs.xdg-desktop-portal-hyprland;
  # };

  
  environment = {
    systemPackages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
      libnotify
      networkmanagerapplet # is it necessary?
      brightnessctl
    ];
  };
}
