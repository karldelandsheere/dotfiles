let
  # hosts
  secret1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";

  # users
  unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";
in
{
  "secret1.age".publicKeys = [ secret1 ];
  "unnamedplayer.age".publicKeys = [ unnamedplayer ];
}
