let
  # hosts
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJQrskPaqpecB86R7CaFDhY5UdBga61W9TucYvCAEPX";
  secret1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";

  # users
  unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";
in
{
  "q3dm10.age".publicKeys = [ q3dm10 ];
  "secret1.age".publicKeys = [ secret1 ];
  "unnamedplayer.age".publicKeys = [ unnamedplayer ];
}
