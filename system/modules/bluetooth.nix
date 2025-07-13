{ config, ... }:
{
  # Bluetooth related stuff (hence the name, right?)
  # -----------------------
  config = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    services.blueman.enable = true;
  };
}
