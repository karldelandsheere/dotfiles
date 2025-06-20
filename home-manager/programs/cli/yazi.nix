{ config, ... }:
{
  config = {
    # Yazi
    # -----
    programs.yazi = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
    };

    # home = {
    #   file.".config/helix".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/config/helix";
    # };
  };
}
