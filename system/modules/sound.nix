# Sound setup (but is all that it is doing?)
# -----------
{ config, pkgs, ... }:
{
  config = {
    security.rtkit.enable = true; 

    services = {
      pulseaudio.enable = false;
      pipewire = {
  		  enable = true;
  		  alsa = {
          enable = true;
          support32Bit = true;
        };
  		  pulse.enable = true;
        wireplumber.enable = true;
        # jack.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      pwvucontrol
    ];
  };
}
