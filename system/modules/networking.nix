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


    # Tailscale setup
    # @todo Setup Tailscale
    # @todo And setup for Dimeritium
    # ------------------------------
    # services.tailscale = {
      # enable = true;
      # authKeyFile = config.age.secrets.dimeritium-tailscale-key.path;
      # useRoutingFeatures = "client";
      # extraUpFlages = [
        # "--login-server=https://headscale.sunflower-cloud.com"
        # "--accept-routes"
        # "--exit-node-allow-lan-access"
      # ];
    # };

    # systemd.services.tailscaled.wantedBy = lib.mkForce []; # no autostart
    # networking.firewall = {
    #   trustedInterfaces = [ "tailscale0" ];
    #   allowedUDPPorts = [ config.services.tailscale.port ];
    #   allowedTCPPorts = [ 22 ];
    # };
  };
}

