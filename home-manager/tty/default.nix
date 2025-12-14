#############################################################################
#
# All the TTY/CLI related stuff that is not mandatory on every host
# plus the configs that are /home/username related.
# Otherwise, it will probably be in system/modules/programs
#
# Next steps:
#   - @todo Test fzf
# 
#############################################################################
  
{ config, pkgs, osConfig, ... }:
{
  config = {
    # CLI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      # aerc                   # Email client
      # basalt                 # @todo check in a couple months where the dev is at
      bitwarden-cli          # Easy access to my vault in tty
      # calcurse               # CalDav client
      cmatrix                # Yeah, I know... like the cool kids
      exiftool
      fastfetch              # Am I a cool already?
      # gurk-rs                # Signal client
      # iamb                   # Element/Synapse client
      mpv                    # Video player
      # termusic               # @todo Test and config that
      ueberzugpp             # Terminal image viewer (needed for yazi)
      yazi                   # A really cool CLI file explorer
      yt-dlp                 # Youtube downloader

      # Screen recording but still have to try it out
      # gpu-screen-recorder
    ];


    programs.yazi.enableZshIntegration = config.programs.zsh.enable;
  };
}
