{ config, pkgs, ... }:
{
  config = {
    # Bottom
    # ------
    programs.bottom.enable = true;

    # home.packages = with pkgs; [
    #   bottom-rs
    # ];

    home = {
      file.".config/bottom".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/bottom/config";
    };
  };
}
