let
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";
  # q3dm11 = "";
in
{
  "secret1.age".publicKeys = [ q3dm10 ];
}
