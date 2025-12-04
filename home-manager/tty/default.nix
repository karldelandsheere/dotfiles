{ config, pkgs, osConfig, ... }:
{
  # All the TTY/CLI related stuff that is not mandatory on every host
  # plus the configs that are /home/username related.
  # Otherwise, it will probably be in system/modules/programs
  # ---------------------------------------------------------
  
  # @todo test fzf

  # CLI programs with config
  # ------------------------
  imports = [
    # Day to day
    # ./aerc
    # ./calcurse
    # ./gurk
    # ./iamb
    # ./jrnl

    # Media
    # ./yt-dlp
  ];


  config = {
    # CLI programs that either don't need config or are on trial
    # ----------------------------------------------------------
    home.packages = with pkgs; [
      cmatrix                # Yeah, I know... like the cool kids
      ffmpeg
      mpv                    # tty video player



      # Day to day
      # basalt @todo check in a couple months where the dev is at

      # Utils
      # exiftool

      # Screen recording but still have to try it out
      # gpu-screen-recorder

      # Media
      # termusic # @todo config that

    ];

    programs.yazi.enableZshIntegration = config.programs.zsh.enable;
  };
}
