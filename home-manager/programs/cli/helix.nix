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
      file.".config/helix".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/config/helix";
    };
  };
}
