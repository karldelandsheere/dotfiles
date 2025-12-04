# General purpose services
# ------------------------
{ config, lib, ... }:
{
  config = {
    services = {
	  	dbus.implementation = "broker";

      udisks2.enable = true;
    
		  xserver = {
        enable = true;
        displayManager.startx.enable = true;
        xkb.layout = config.nouveauxParadigmes.kbLayout;
      };

      # If the whole system is encrypted and password protected at boot,
      # no need to type a second login right after
      # ------------------------------------------
      getty = lib.mkIf config.nouveauxParadigmes.encryption.enable {
        autologinUser = "unnamedplayer";
      };
    };
  };
}
