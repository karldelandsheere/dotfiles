let
  # Hosts (keys stored in /etc/ssh)
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHkeUywtXBywY5iC0IM0y2s7c/oY7w9ohvvRbLbh6vY";
  hosts = [ q3dm10 ];

  # Users (keys stored in /home/{user}/.ssh)
  unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDS5LeM6v9nnZHlQ9rVZ0QppIvKKMvbMYXg9X9VPDRb";
in
{
  "auth/mail/karl_at_delandsheere_be.age".publicKeys = hosts ++ [ unnamedplayer ];
  "auth/mail/karl_at_nouveaux-paradigmes_be.age".publicKeys = hosts ++ [ unnamedplayer ];
  "auth/tailscale/dimeritium.age".publicKeys = hosts ++ [ unnamedplayer ];
}
