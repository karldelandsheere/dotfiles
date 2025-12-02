# jrnl: cli journaling utility
# ----------------------------
{ config, pkgs, ... }:
{
  config = {
    home = {
      packages = with pkgs; [ jrnl ];
      file.".config/jrnl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/jrnl/config";
    };
  };
}
