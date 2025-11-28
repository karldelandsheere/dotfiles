# Power management and hibernation
# https://nixos.wiki/wiki/Laptop
# https://nixos.wiki/wiki/Hibernation
# -----------------------------------
{ config, lib, pkgs, ... }:
{
  options.nouveauxParadigmes = {
    hibernation = {
      enable = lib.mkEnableOption "Enable hibernation? Defaults to false.";

      resume = {
        device = lib.mkOption {
          type = lib.types.str;
          default = "/dev/mapper/cryptroot";
          description = "Which device to resume from after hibernation? Defaults to /dev/mapper/cryptroot";
        };

        offset = lib.mkOption {
          type    = lib.types.str;
          default = "0";
          description = "Offset to resume after hibernation. Defaults to 0. To find the value, use: sudo btrfs inspect-internal map-swapfile -r /swap/swapfile";
        };
      };
    };
  };


  config = {
    # Packages and utilities
    # ----------------------
    environment.systemPackages = with pkgs; [
      acpi
      powerstat
      # linuxKernel.packages.linux_zen.cpupower
    ];


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
      logind.settings.Login = {
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
        HandlePowerKeyLongPress = "poweroff";

        HandleLidSwitch = if config.nouveauxParadigmes.hibernation.enable
          then "hibernate" # "suspend-then-hibernate"
          else "suspend";

        HandlePowerKey = if config.nouveauxParadigmes.hibernation.enable
          then "hibernate"
          else "suspend";
      };
    };


    # I chose a swapfile
    # ------------------
    swapDevices = [ {
      device = "/swap/swapfile";
      size = config.nouveauxParadigmes.swapSize;
    } ];


    # Resume after hibernation
    # ------------------------
    boot.kernelParams = [
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.hibernation.enable ) [
      "resume=${config.nouveauxParadigmes.hibernation.resume.device}"
      "resume_offset=${config.nouveauxParadigmes.hibernation.resume.offset}"
    ];
  };
}
