{ config, pkgs, ... }:
{
  config = {
    # Signal
    # ------
    home = {
      packages = with pkgs; [ signal-desktop ];
      file.".config/Signal/Preferences".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/gui/signal/config/Preferences";
    };
  };
}
