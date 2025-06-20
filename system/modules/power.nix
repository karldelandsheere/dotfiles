{ pkgs, ... }:

{
  # More stuff to come here, later...
  # If not, I'll put this in the default.nix
  # ----------------------------------------

  # services.power-profiles.daemon.enable = true;

  # services.powerstation.enable = true;
  # services.upower.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave"; #performance, ondemand, schedutil
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
  };


  environment.systemPackages = with pkgs; [
    acpi
    # linuxKernel.packages.linux_zen.cpupower
    powerstat
  ];
}

