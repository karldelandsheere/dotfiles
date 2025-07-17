{ config, inputs, ... }:
{
  config = {
    environment.systemPackages = [ inputs.agenix.packages.${config.nouveauxParadigmes.system}.default ];

    age = {
      secrets = {
        "auth/mail/karl_at_delandsheere_be".file = ../../secrets/auth/mail/karl_at_delandsheere_be.age;
        "auth/mail/karl_at_nouveaux-paradigmes_be".file = ../../secrets/auth/mail/karl_at_nouveaux-paradigmes_be.age;
        "auth/tailscale/dimeritium".file = ../../secrets/auth/tailscale/dimeritium.age;
      };
    #   # wg-DE = {
    #   #   file = ../../secrets/wg-DE.age;
    #   #   path = "/etc/wireguard/DE.conf";
    #   # };
    };
  };
}
