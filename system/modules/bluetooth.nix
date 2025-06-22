{ ... }:
{
  # More stuff to come here, later...
  # If not, I'll put this in the default.nix
  # ----------------------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
}

