{ config, pkgs, ... }:
{
  config = {
    # jrnl: cli journaling utility
    # ----------------------------
    home = {
      packages = with pkgs; [ jrnl ];
      file.".config/jrnl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/jrnl/config";
    };
  };
}
