{ config, inputs, ... }:
{
  config = {
    environment.systemPackages = [ inputs.agenix.packages.${config.nouveauxParadigmes.system}.default ];
    age = {
      # identityPaths = [
        
      # ];
      # secrets = {
      #   # Hosts
      #   q3dm10 = {
      #     file  = ../../secrets/q3dm10-secrets.age;
      #     group = "wheel";
      #     mode  = "0440";
      #   };

      #   # # Users
      #   unnamedplayer = {
      #     file = ../../secrets/unnamedplayer-secrets.age;
      #     owner = "unnamedplayer";
      #   };
      # };
    #   # wg-DE = {
    #   #   file = ../../secrets/wg-DE.age;
    #   #   path = "/etc/wireguard/DE.conf";
    #   # };
    };
  };
}
