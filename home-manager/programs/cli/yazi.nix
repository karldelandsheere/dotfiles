{ config, ... }:
{
  config = {
    # Yazi
    # -----
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    # home = {
    #   file.".config/helix".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/config/helix";
    # };
  };
}
