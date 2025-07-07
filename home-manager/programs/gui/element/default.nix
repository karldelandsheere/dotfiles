# Element: Matrix/Synapse client
# ------------------------------
{ config, osConfig, pkgs, ... }:
{
  config = {
    home = {
      packages = with pkgs; [ element-desktop ];
      file.".config/Element/config.json".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.dotfiles}/home-manager/programs/gui/element/config/config.json";
    };
  };
}
