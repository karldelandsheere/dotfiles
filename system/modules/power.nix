{ pkgs, ... }:
{
  # Power management
  # https://nixos.wiki/wiki/Laptop
  # https://nixos.wiki/wiki/Hibernation
  # -----------------------------------


  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave"; #performance, ondemand, schedutil
  };


  services = {
    # services.powerstation.enable = true;
    # services.upower.enable = true;

    
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


    logind = {
      lidSwitch = "suspend";
      # lidSwitch = "suspend-then-hibernate"; # when hibernate will be implemented
      lidSwitchExternalPower = "suspend";
      lidSwitchDocked = "ignore";
      # powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    };
  };


  environment.systemPackages = with pkgs; [
    acpi
    # linuxKernel.packages.linux_zen.cpupower
    powerstat
  ];
}

