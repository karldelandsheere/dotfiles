# Power management and hibernation
# https://nixos.wiki/wiki/Laptop
# https://nixos.wiki/wiki/Hibernation
# -----------------------------------
{ config, pkgs, ... }:
{
  config = {
    # Enable powerManagement and set it to powersave
    # ----------------------------------------------
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave"; #performance, ondemand, schedutil
    };


    services = {
      upower.enable = true;
    
      # Service to help with power management
      # -------------------------------------
      tlp = {
        enable = true;

        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 40;

          # Optional helps save long term battery health
          # --------------------------------------------
          START_CHARGE_THRESH_BAT0 = 30; # 30 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging
        };
      };


      # Lid and powerKey events
      # -----------------------
      logind = {
        lidSwitch = "suspend-then-hibernate";
        lidSwitchExternalPower = "suspend";
        lidSwitchDocked = "ignore";
        powerKey = "hibernate";
        powerKeyLongPress = "poweroff";
      };
    };


    # I chose a swapfile
    # ------------------
    swapDevices = [ {
      device = "/swap/swapfile";
      size = 96*1024; # Swap should be the size of RAM
    } ];


    # Resume after hibernation
    # ------------------------
    boot.kernelParams = [
      "resume=/dev/mapper/cryptroot"
      "resume_offset=1108328"
      "acpi_enforce_resources=lax" # Shush harmless acpi warnings
    ];


    # Other packages and utilities
    # ----------------------------
    environment.systemPackages = with pkgs; [
      acpi
      powerstat
      # linuxKernel.packages.linux_zen.cpupower
    ];
  };
}
