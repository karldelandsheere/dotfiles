{ ... }:

{
  # More stuff to come here, later...
  # If not, I'll put this in the default.nix
  # ----------------------------------------

  services.power-profiles.daemon.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave"; #performance, ondemand, schedutil
  };
}

