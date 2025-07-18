{ config, osConfig, pkgs, ... }:
{
  config = {
    # Aerc
    # ----
    # programs.aerc = {
    #   enable = true;
    #   extraConfig.general.unsafe-accounts-conf = true;
    # };

    home = {
      packages = [ pkgs.aerc ];
      file.".config/aerc".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.nouveauxParadigmes.dotfiles}/home-manager/programs/cli/aerc/config";
    };
  };
}
