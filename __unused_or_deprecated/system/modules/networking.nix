###############################################################################
#
# Network related stuff (who would have guessed?)
# 
###############################################################################

{ config, pkgs, lib, inputs, ... }: let
  cfg = config.nouveauxParadigmes;
in
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
    # Networking parts activation and settings
    networking = {
      hostName              = cfg.hostname;
      networkmanager.enable = true;
      enableIPv6            = true;

      # Firewall activation and config for Tailscale
      firewall              = {
        enable            = true;
        allowedUDPPorts   = [ config.services.tailscale.port ];
        allowedTCPPorts   = [ 22 ];
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
    };


    environment.systemPackages = [
      # inputs.globalprotect-openconnect.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    # services.globalprotect = {
    #   enable = true;
    # };


    # Tailscale
    # @todo Not every user will need or should have access to tailscale,
    #       maybe there should be a needlist or something.
    services.tailscale = {
        enable             = true;
        useRoutingFeatures = "client";
    };
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    systemd.services.tailscaled.wantedBy  = lib.mkForce []; # no autostart
  };
}
