# General purpose services
# ------------------------
{ config, ... }:
{
  config = {
    services = {
	  	dbus.implementation = "broker";
    
		  xserver = {
        enable = true;
        displayManager.startx.enable = true;
      };
    };
  };
}
