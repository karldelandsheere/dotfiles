###############################################################################
#
# Core options that are too small for having their own files.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { config, pkgs, ...}:
  {
    config = {
      console = {
        earlySetup = true;
        font = "Lat2-Terminus16";
        useXkbConfig = true;
      };

      fonts.packages = with pkgs; [
        font-awesome
        nerd-fonts.jetbrains-mono
      ];
      
      hardware.enableAllFirmware = true; # Don't remember what it does exactly

      i18n = {
        defaultLocale = "en_US.UTF-8";
        inputMethod = {
          enable = true;
          type = "ibus";
        };
      };

      services = {
        dbus.implementation = "broker";
        udisks2.enable = true; # DBus service that allows apps to query/manipulate storage devices
      };
    };
  };
}

