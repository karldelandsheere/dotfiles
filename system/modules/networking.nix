{ config, ... }:
{
  # Network related stuff (who would have guessed?)
  # ---------------------
  config = {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = true;

      # Firewall setup
      # --------------
      firewall.enable = true;

      # VPN setup
      # @todo setup for each VPN I need
      # -------------------------------
      # wireguard = {
      #   enable = true;
      #   interfaces = {
          
      #   };
      # };
    };

    # Tailscale setup
    # @todo setup for Dimeritium
    # --------------------------
    # services.tailscale = {
    #   enable = true;
    # };
  };
}

