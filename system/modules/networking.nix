{ config, pkgs, ... }:
{
  # Network related stuff (who would have guessed?)
  # ---------------------
  config = {
    environment.systemPackages = with pkgs; [
      mullvad
    ];

    services.mullvad-vpn.enable = true;
  
    networking = {
      hostName = config.nouveauxParadigmes.hostname;
      networkmanager.enable = true;
      enableIPv6 = true;

      # Firewall setup
      # --------------
      firewall.enable = true;
    };


    # Tailscale setup
    # @todo Setup Tailscale
    # @todo And setup for Dimeritium
    # ------------------------------
    # services.tailscale = {
    #   enable = true;
    # };
  };
}

