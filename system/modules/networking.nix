{ ... }:
{
  # More stuff to come here, later...
  # If not, I'll put this in the default.nix
  # ----------------------------------------
  networking = {
    networkmanager.enable = true;
    enableIPv6 = true;
    firewall.enable = true;
  };

  # services.tailscale = {
  #   enable = true;
  # };
}

