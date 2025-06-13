{ config, ... }:
{
  config = {
    # Helix
    # -----
    programs.helix = {
      enable = true;
      defaultEditor = true;
    };

    home = {
      sessionVariables.EDITOR = "hx";
      file.".config/helix".source = config.lib.file.mkOutOfStoreSymLink "/etc/nixos/home-manager/desktop/config/helix";
    };
  };
}
