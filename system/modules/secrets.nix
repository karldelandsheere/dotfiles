{
  age = {
    secrets = {
      # Hosts
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
