let
  # Hosts (keys stored in /etc/ssh)
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHkeUywtXBywY5iC0IM0y2s7c/oY7w9ohvvRbLbh6vY";

  # Users (keys stored in /home/{user}/.ssh)
  unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDS5LeM6v9nnZHlQ9rVZ0QppIvKKMvbMYXg9X9VPDRb";
in
{
  "q3dm10-secrets.age".publicKeys = [ q3dm10 unnamedplayer ];
  "unnamedplayer-secrets.age".publicKeys = [ unnamedplayer ];
}
