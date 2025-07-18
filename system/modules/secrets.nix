{ config, inputs, ... }:
{
  config = {
    environment.systemPackages = [ inputs.agenix.packages.${config.nouveauxParadigmes.system}.default ];

    age = {
      secrets = {
        "auth/bw" = {
          file = ../../secrets/auth/bw.age;
          owner = "unnamedplayer";
        };
        "auth/mail/karl_at_delandsheere_be".file = ../../secrets/auth/mail/karl_at_delandsheere_be.age;
        "auth/mail/karl_at_nouveaux-paradigmes_be".file = ../../secrets/auth/mail/karl_at_nouveaux-paradigmes_be.age;
        "auth/matrix/dimeritium" = {
          file = ../../secrets/auth/matrix/dimeritium.age;
          owner = "unnamedplayer";
        };
        "auth/tailscale/dimeritium" = {
          file = ../../secrets/auth/tailscale/dimeritium.age;
          owner = "unnamedplayer";
        };
      };
    #   # wg-DE = {
    #   #   file = ../../secrets/wg-DE.age;
    #   #   path = "/etc/wireguard/DE.conf";
    #   # };
    };
  };
}
