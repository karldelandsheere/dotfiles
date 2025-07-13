# Bottom
# ------
{ config, pkgs, ... }:
{
  config = {
    programs.bottom.enable = true;

    home = {
      file.".config/bottom".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/bottom/config";

      # packages = with pkgs; [
      #   bottom-rs
      # ];
    };
  };
}
