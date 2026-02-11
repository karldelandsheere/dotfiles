###############################################################################
#
# Desktop environment config.
# Heavily TTY oriented, with Ghostty, on Niri and Noctalia.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.desktop = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    imports = [
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.graphics
    ];
    
    config = {
      # @todo Change the options paradigm:
      #   If this file is imported, set cfg.gui = true;

      environment = {
        # Launches niri at autologin, but only from tty1
        # -l : https://github.com/YaLTeR/niri/issues/1914 (thanks nisby!)
        # @todo move this in niri's config
        loginShellInit = ''
          if [ "$(tty)" = "/dev/tty1" ]; then
            niri-session -l
          fi
        '';

        sessionVariables = {
          NIXOS_OZONE_WL = "1";        # Use Ozone Wayland for Electron apps
          QT_QPA_PLATFORM = "wayland";
          # WLR_NO_HARDWARE_CURSORS = "1"; # Reactivate only if cursor glitches
        };

        systemPackages = with pkgs; [
          xwayland-satellite   # Rootless Xwayland integration
        ];
      };

      services.xserver = {
        enable = true;
        displayManager.startx.enable = true; # No need for a DM
      };
    };
  };

  flake.homeModules.desktop = { ... }:
  {
    imports = [
      self.homeModules.niri
      self.homeModules.noctalia
    ];
  };
}
