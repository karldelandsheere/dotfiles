{ ... }:

{
  services = {
		dbus.implementation = "broker";

		xserver = {
      enable = true;

      # No need for a DM screen to greet me
      displayManager.startx.enable = true;
    };

		locate.enable = true;

    ollama = {
      enable = true;
      loadModels = [ "deepseek-coder-v2:16b" ];
    };
  };
}
