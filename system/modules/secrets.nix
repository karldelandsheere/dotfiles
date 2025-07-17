{
  age = {
    secrets = {
      # Hosts
      q3dm10 = {
        file  = ../../secrets/q3dm10.age;
        group = "wheel";
        mode  = "0440";
      };
      secret1 = {
        file  = ../../secrets/secret1.age;
        group = "wheel";
        mode  = "0440";
      };

      # Users
      unnamedplayer = {
        file = ../../secrets/unnamedplayer.age;
        owner = "unnamedplayer";
      };
    };
    # wg-DE = {
    #   file = ../../secrets/wg-DE.age;
    #   path = "/etc/wireguard/DE.conf";
    # };
  };
}
