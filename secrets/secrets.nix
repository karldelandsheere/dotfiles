let
  # hosts
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUureEFJiD4kg6mzU777h3p+4IVRymDRKsZg4k+JkiC";

  # users
  unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";
in
{
  "q3dm10.age".publicKeys = [ q3dm10 ];
  "unnamedplayer.age".publicKeys = [ unnamedplayer ];
}
