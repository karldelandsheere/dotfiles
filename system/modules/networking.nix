###############################################################################
#
# Network related stuff (who would have guessed?)
# 
###############################################################################

{ config, pkgs, lib, ... }:
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    hostname = lib.mkOption {
      type        = lib.types.str;
      default     = "unnamedhost";
      description = "What is the host's name? Defaults to unnamedhost.";
    };
  };


  config = {
    # System-wide packages related to network stuff
    environment.systemPackages = with pkgs; [
      pkgs.mullvad # Really needed?
    ];


    # Networking parts activation and settings
    networking = {
      hostName              = config.nouveauxParadigmes.hostname;
      networkmanager.enable = true;
      enableIPv6            = true;

      # Firewall activation and config for Tailscale
      firewall              = {
        enable            = true;
        allowedUDPPorts   = [ config.services.tailscale.port ];
        allowedTCPPorts   = [ 22 ];
        trustedInterfaces = [ "tailscale0" ];
      };
    };


    # Network services
    services = {
      # VPN
      mullvad-vpn.enable = true;

      # OpenSSH
      openssh = {
        enable   = true;
        hostKeys = [
          { path = "/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
          { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
        ];
        # openFirewall = false; # for now
        # banner = "";
      };

      # Tailscale
      tailscale = {
        enable             = true;
        useRoutingFeatures = "client";
      };
    };


    # Systemd for Tailscale
    systemd.services.tailscaled.wantedBy = lib.mkForce []; # no autostart
  };
}
