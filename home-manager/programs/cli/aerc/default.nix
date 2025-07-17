{ config, pkgs, ... }:
{
  config = {
    # Aerc
    # ----
    programs.aerc = {
      enable = true;
      extraConfig.general.unsafe-accounts-conf = true;
    };

    # home.packages = with pkgs; [
    # ];

    # home = {
    #   file.".config/aerc".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/aerc/config";
    # };
  };
}
