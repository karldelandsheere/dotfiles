{ pkgs, ... }:
{
  # Power management and hibernation
  # https://nixos.wiki/wiki/Laptop
  # https://nixos.wiki/wiki/Hibernation
  # -----------------------------------


  # Enable powerManagement and set it to powersave
  # ----------------------------------------------
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave"; #performance, ondemand, schedutil
  };


  services = {
    # powerstation.enable = true;
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


  # Set up the swapfile for hibernation (should be the size of RAM)
  # -----------------------------------
  swapDevices = [ {
    device = "/swap/swapfile";
    size = 96*1024;
  } ];


  # Resume after hibernation
  # ------------------------
  boot = {
    kernelParams = [ "resume_offset=6300928" ];
    resumeDevice = "/dev/disk/by-uuid/46aa91ff-95fb-4bf7-91bd-828ca14115be";
  };


  #
  # 
  environment.systemPackages = with pkgs; [
    acpi
    # linuxKernel.packages.linux_zen.cpupower
    powerstat
  ];
}

