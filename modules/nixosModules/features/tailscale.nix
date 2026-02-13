###############################################################################
#
# Tailscale generic config.
#
# For host|user specific options, go to host|user's config.
# 
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.tailscale = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      # @todo Not every user will need or should have access to tailscale,
      #       maybe there should be a needlist or something.
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
    };
  };
}
