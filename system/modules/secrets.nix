{ config, inputs, ... }:
{
  config = {
    environment.systemPackages = [ inputs.agenix.packages.${config.nouveauxParadigmes.system}.default ];

    age = {
      secrets = {
        q3dm10.file = ../../secrets/q3dm10-secrets.age;
        dimeritium-tailscale-key.file = ../../secrets/dimeritium-tailscale-key.age;
      };
    #   # wg-DE = {
    #   #   file = ../../secrets/wg-DE.age;
    #   #   path = "/etc/wireguard/DE.conf";
    #   # };
    };
  };
}
