{ ... }:

{
  imports = [
    ./boot.nix
    ./impermanence.nix
    # ./luks.nix
    ./swapfile.nix
  ];


  # Yeah, read it was better to set that, but honnestly don't know why
  # ------------------------------------------------------------------
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
