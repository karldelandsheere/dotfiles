{ config, pkgs, inputs, settings, lib, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  config = {
    programs.niri.enable = true;

    # @todo Could we get away with the full absolute path?
    home = {
      file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/home-manager/wm/niri/config.kdl";

      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };
    };

    xdg.portal = {
      config.common = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        # "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome # for niri
      ];
    };


    # @todo make this shell agnostic
    programs.zsh.profileExtra = ''
      exec niri --session
    '';
  };  
}
