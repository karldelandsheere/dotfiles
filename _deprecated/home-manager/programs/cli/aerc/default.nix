# Aerc, a TUI email client
# ------------------------
{ config, osConfig, pkgs, ... }: let
  configPath = "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/aerc/config";
in
{
  config = {
    programs.aerc.enable = true;

    home.file = {
      ".config/aerc/aerc.conf".source = config.lib.file.mkOutOfStoreSymlink "${configPath}/aerc.conf";
      ".config/aerc/binds.conf".source = config.lib.file.mkOutOfStoreSymlink "${configPath}/binds.conf";
      ".config/aerc/stylesets".source = config.lib.file.mkOutOfStoreSymlink "${configPath}/stylesets";
    };
  };
}
