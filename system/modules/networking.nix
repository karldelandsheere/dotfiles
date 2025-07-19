{ config, pkgs, lib, ... }:
{
  # Network related stuff (who would have guessed?)
  # ---------------------
  config = {
    # And finally the whole network
    # -----------------------------  
    networking = {
      hostName = config.nouveauxParadigmes.hostname;
      networkmanager.enable = true;
      enableIPv6 = true;

      # Firewall
      # --------
      firewall.enable = true;
    };


    # OpenSSH
    # -------
    services.openssh = {
      enable = true;
      hostKeys = [
        { path = "/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
        { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
      ];
      # openFirewall = false; # for now
      # banner = "";
    };

    
    # Mullvad VPN
    # -----------
    environment.systemPackages = [ pkgs.mullvad ]; # Really needed?
    services.mullvad-vpn.enable = true;


    # Tailscale
    # ---------
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    systemd.services.tailscaled.wantedBy = lib.mkForce []; # no autostart
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 ];
    };
  };
}
