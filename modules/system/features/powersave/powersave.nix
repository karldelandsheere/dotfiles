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
  flake.modules.nixos = {
    powersave = { lib, config, pkgs, ... }:
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

        # Ressources to persist
        features.impermanence.persist.directories = [
          "/etc/tuned"
          "/var/lib/upower"
        ];
      };
    };


    # Additional options to Power management for AMD
    powersave_amd = { config, ... }:
    {
      config = {
        # https://wiki.cachyos.org/configuration/general_system_tweaks/#enable-rcu-lazy
        boot.kernelParams = [ "rcutree.enable_rcu_lazy=1" ];

        services.auto-epp = {
          enable = true;
          settings.Settings = {
            epp_state_for_AC  = "balance_performance";
            epp_state_for_BAT = "power";
          };
        };
      };
    };
  };
}
