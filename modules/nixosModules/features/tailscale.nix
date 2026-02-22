###############################################################################
#
# Tailscale generic config.
#
# For host|user specific options, go to host|user's config.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.tailscale = { lib, config, ... }:
  {
    config = {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
      };
      
      systemd.services.tailscaled.wantedBy = lib.mkForce []; # no autostart
      
      networking.firewall = {
        allowedUDPPorts = [ config.services.tailscale.port ];
        allowedTCPPorts = [ 22 ];
        trustedInterfaces = [ "tailscale0" ];
      };

      features.impermanence.persist.directories = [ "/var/lib/tailscale" ];
    };
  };
}
