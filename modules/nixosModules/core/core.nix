###############################################################################
#
# Core options that are too small for having their own files.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { config, pkgs, lib, ...}:
  {
    config = {
      console = {
        earlySetup = true;
        font = lib.mkDefault "Lat2-Terminus16";
        useXkbConfig = true;
      };

      fonts.packages = with pkgs; [
        font-awesome
        nerd-fonts.jetbrains-mono
      ];
      
      hardware.enableRedistributableFirmware = true;

      i18n = {
        defaultLocale = lib.mkDefault "en_US.UTF-8";
        inputMethod = {
          enable = true;
          type = "ibus";
        };
      };

      time.timeZone = lib.mkDefault "Europe/Brussels";

      services = {
        dbus.implementation = "broker";
        udisks2.enable = true; # DBus service that allows apps to query/manipulate storage devices
      };

      system.stateVersion = lib.mkDefault "25.11";
    };
  };
}

