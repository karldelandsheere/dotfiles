# Element: Matrix/Synapse client
# ------------------------------
{ config, pkgs, ... }:
{
  config = {
    home = {
      packages = with pkgs; [ element-desktop ];
      file.".config/Element/config.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/gui/element/config/config.json";
    };
  };
}
