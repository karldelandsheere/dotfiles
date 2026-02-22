###############################################################################
#
# Power management
#
# Resources:
# - https://nixos.wiki/wiki/Laptop
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.powersave = { lib, config, pkgs, ...}: let
    users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
  in
  {
    config = {
      environment.systemPackages = with pkgs; [
        acpi
        powerstat
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "powersave";
        powertop.enable = true;
      };

      services = {
        # Lid and powerKey events
        logind.settings.Login = {
          HandleLidSwitch = lib.mkDefault "suspend";
          HandleLidSwitchExternalPower = "suspend";
          HandleLidSwitchDocked = "ignore";
          HandlePowerKey = lib.mkDefault "suspend";
          HandlePowerKeyLongPress = "poweroff";
        };

        # https://documentation.ubuntu.com/server/explanation/performance/perf-tune-tuned/#static-vs-dynamic-tuning
        tuned = {
          enable = true;
          settings.dynamic_tuning = true;
        };

        # https://wiki.archlinux.org/title/Laptop#UPower
        upower = {
          enable = true;
          percentageAction = 3;
          percentageLow = 15;
          percentageCritical = 10;
          usePercentageForPolicy = true;
        };
      };
      
      # https://wiki.nixos.org/wiki/NetworkManager#Power_Saving
      networking.networkmanager.wifi.powersave = true;

      environment = {
        persistence."/persist" = lib.mkIf config.features.impermanence.enable {
          directories = [
            "/etc/tuned"
            "/var/lib/upower"
          ];
        };
      };
    };
  };
}
