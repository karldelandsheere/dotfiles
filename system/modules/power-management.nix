###############################################################################
# 
# Power management and hibernation
#
# Resources:
# - https://nixos.wiki/wiki/Laptop
# - https://nixos.wiki/wiki/Hibernation
#
# Next steps:
# -----------
# - @todo Find out why I have this error when resuming from hibernation
#   "BTRFS error: failed to open device for path /dev/mapper/cryptroot with flags 0x3: -16"
# 
###############################################################################

{ config, lib, pkgs, ... }:
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    hibernation = {
      enable = lib.mkEnableOption "Enable hibernation? Defaults to false.";

      resume = {
        device = lib.mkOption {
          type        = lib.types.str;
          default     = "/dev/mapper/cryptroot";
          description = "Which device to resume from after hibernation? Defaults to /dev/mapper/cryptroot";
        };

        offset = lib.mkOption {
          type        = lib.types.str;
          default     = "0";
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

    boot.kernelParams = [
      # ...
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.hibernation.enable ) [
      # Resume after hibernation
      "resume=${config.nouveauxParadigmes.hibernation.resume.device}"
      "resume_offset=${config.nouveauxParadigmes.hibernation.resume.offset}"
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.cpuFlavor == "amd" ) [
      # https://wiki.cachyos.org/configuration/general_system_tweaks/#enable-rcu-lazy
      "rcutree.enable_rcu_lazy=1"
    ];


    # Enable powerManagement and set it to powersave
    # ----------------------------------------------
    powerManagement = {
      enable          = true;
      cpuFreqGovernor = "powersave"; #performance, ondemand, schedutil
      powertop.enable = true;
    };


    services = {
      auto-epp = lib.mkIf ( config.nouveauxParadigmes.cpuFlavor == "amd" ) {
        enable = true;
        settings.Settings = {
          epp_state_for_AC  = "balance_performance";
          epp_state_for_BAT = "power";
        };
      };

      # https://documentation.ubuntu.com/server/explanation/performance/perf-tune-tuned/#static-vs-dynamic-tuning
      tuned = {
        enable                  = true;
        settings.dynamic_tuning = true;
      };


      # https://wiki.archlinux.org/title/Laptop#UPower
      upower = {
        enable                 = true;
        criticalPowerAction    = "Hibernate";
        percentageAction       = 5;
        percentageLow          = 15;
        percentageCritical     = 10;
        usePercentageForPolicy = true;
      };
    

      # Lid and powerKey events
      # -----------------------
      logind.settings.Login = {
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked        = "ignore";
        HandlePowerKeyLongPress      = "poweroff";

        HandleLidSwitch = if config.nouveauxParadigmes.hibernation.enable
          then "hibernate" # "suspend-then-hibernate"
          else "suspend";

        HandlePowerKey = if config.nouveauxParadigmes.hibernation.enable
          then "hibernate"
          else "suspend";
      };
    };


    # https://wiki.nixos.org/wiki/NetworkManager#Power_Saving
    networking.networkmanager.wifi.powersave = true;


    # https://wiki.nixos.org/wiki/Power_Management
    systemd.sleep.extraConfig = lib.mkIf config.nouveauxParadigmes.hibernation.enable ''
      HibernateDelaySec=15m
    '';
  };
}
