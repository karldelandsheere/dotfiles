{ config, pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./terminal.nix
  # ] ++ lists.optionals (system == 'x86_64-linux') [
    ./onlyoffice.nix
  ];

  home = {
    packages = with pkgs; [
      # bambu-studio
      bitwarden
      blender
      element-desktop
      # nautilus
      opencloud-desktop
      openscad
      # orca-slicer
      prusa-slicer
      #qbittorrent
      signal-desktop
      thunderbird
      #vlc
      vscodium

    # ] ++ lists.optionals (system == 'x86_64-linux') [
      anytype
    ];

    file.".config/Element/config.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/config/element/config.json";
  };
}
