let
  # hosts
  q3dm10 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHkeUywtXBywY5iC0IM0y2s7c/oY7w9ohvvRbLbh6vY";

  # users
  # unnamedplayer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrqj/og1fQM9uXpBnjbluA5GP0UohBaMiTdGH41BbxC";
  unnamedplayer = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7EVC0BRYT3c1o5zTAIUcXuD4zxyn3Jw8LxQ44/oJ0BiytR0on6C/q608q6UUv3hjltlXLk2VKCDyZXKCiDlfmIq3HbfRQfTraj6QLZ5isFtEfnxOME8BlDvXihSfc8e0iP64DYlqBHsFUYwoKl9/cchgY5kSMfstikclDYPrbv2YHE9oqtjwIRHlTLWJjSxGHgs8bLaPvvBjEFtQlHBdgLLE6j+ztupekg+JHR6tqQhR+TfAviuCP0qPoM+Iq7v0j10sa7mJGwW9GLx3p796hg1graUDhPRYe4puDvybc35Kk0BQn7K6iakVhH/Rtx2jT5SeGtaGG39c0BT+LEUvnfMO6C53BVIt2+nxEkfGQsUz5u2+2+NRJLuoGC/E1wpSn5jXWmWSv4hxMizdo0YBH9NcAfgM5c81bZ4NY/Vw3/lbDQ0LDPTtVCtURfLgkRvxA1iFR81JOGXN/JCihB7T+71g2shU4Myeljtex4MfFLq+YHaesJLHN8STHdKDddS6ofQ/SAuyWberYe5kWFGEX5AyMYvOvvv1uEbMzqzkODFI0PNTPgAxqhpLjq2GTL/OZWK0IiIkxkrC87R112/ty0yEFQ+lhzGIUpVh3EcDDOX9SpzD5xAthX8R/KiPliqP+KzAaw8iFin8a+4Tu0kFkDAD+22yo4bFUfFMGswkwNQ==";
in
{
  "q3dm10.age".publicKeys = [ q3dm10 unnamedplayer ];
  "unnamedplayer.age".publicKeys = [ unnamedplayer ];
}
