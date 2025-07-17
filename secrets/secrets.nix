let
  # hosts
  # q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJQrskPaqpecB86R7CaFDhY5UdBga61W9TucYvCAEPX";
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHkeUywtXBywY5iC0IM0y2s7c/oY7w9ohvvRbLbh6vY";

  # users
  unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";
in
{
  "q3dm10.age".publicKeys = [ q3dm10 unnamedplayer ];
  "unnamedplayer.age".publicKeys = [ unnamedplayer ];
}
