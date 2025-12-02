# yt-dlp
# ------
{ config, ... }:
{
  config = {
    programs.yt-dlp.enable = true;

    # home = {
    #   file.".config/yt-dlp".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/cli/yt-dlp/config";
    # };
  };
}
