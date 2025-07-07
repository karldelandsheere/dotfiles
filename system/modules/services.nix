# General purpose services
# ------------------------
{ config, ... }:
{
  config = {
    services = {
	  	dbus.implementation = "broker";

      udisks2.enable = true;
    
		  xserver = {
        enable = true;
        displayManager.startx.enable = true;
      };
    };
  };
}
