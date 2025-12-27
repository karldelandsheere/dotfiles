{ config, ... }:
{
  config = {
    age = {
      identityPaths = [ "~/.ssh/id_ed25519" ];

      secrets = {
        "auth/bw".file = ../../secrets/auth/bw.age;
        "auth/mail/karl_at_delandsheere_be".file = ../../secrets/auth/mail/karl_at_delandsheere_be.age;
        "auth/mail/karl_at_nouveaux-paradigmes_be".file = ../../secrets/auth/mail/karl_at_nouveaux-paradigmes_be.age;
        "auth/matrix/dimeritium".file = ../../secrets/auth/matrix/dimeritium.age;
        "auth/tailscale/dimeritium".file = ../../secrets/auth/tailscale/dimeritium.age;
      };
    };
  };
}
