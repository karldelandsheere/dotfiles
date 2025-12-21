#############################################################################
#
# All programs related stuff that is not mandatory on every host
# plus the configs that are /home/username related.
# Otherwise, it will probably be in system/modules/programs
# 
#############################################################################
  
{ config, pkgs, osConfig, lib, ... }: let
  cfg = osConfig.nouveauxParadigmes;
  username = "unnamedplayer";
in
{
  config = {
    home = {
      # Programs that don't need a lot of config
      # ----------------------------------------
      packages = with pkgs; [
        # TUI/CLI programs
        # ----------------
        # aerc                   # Email client
        # basalt                 # @todo check back in a couple months
        bitwarden-cli          # Easy access to my vault in tty
        bottom                 # Process/system monitor
        # calcurse               # CalDav client
        cmatrix                # Yeah, I know... like the cool kids
        curl
        exiftool
        fastfetch              # Am I a cool already?
        ffmpeg
        # gurk-rs                # Signal client
        helix                  # Helix > Vim imho
        # iamb                   # Element/Synapse client
        mpv                    # Video player
        progress               # Follow the progression of any command
        scooter                # Directory wide search & replace
        # termusic               # @todo Test and config that
        tree                   # Kinda ls but as a tree
        ueberzugpp             # Terminal image viewer (needed for yazi)
        yazi                   # A really cool CLI file explorer
        yt-dlp                 # Youtube downloader
      ]

       # GUI programs
       ++ lib.lists.optionals ( cfg.gui.enable ) [
        bambu-studio           # Slicer for my Bambu printers
        bitwarden-desktop      # Passwords & stuff
        # blender
        ghostty                # Terminal emulator
        # mullvad-browser        # Highly privacy focused browser
        # opencloud-desktop
        openscad               # Code based CAD
        prusa-slicer           # Slicer for my Prusa printers
        # qbittorrent
        signal-desktop         # Privacy focused messaging
        vivaldi                # Privacy focused browser
        # vlc                  # Replaced by mpv (tty video player)
        vscodium               # Foss version of VSCode
      ]

       # GUI and unfree programs
       ++ lib.lists.optionals ( cfg.gui.enable && osConfig.nixpkgs.config.allowUnfree ) [
        obsidian               # Markdown note taking app
        termius                # Cross-platform SSH client

        # Graphic design
        # Not working on 20250725, try again later if no good alternative found
        # inputs.affinity-nix.packages.x86_64-linux.designer
        # inputs.affinity-nix.packages.x86_64-linux.photo
        # inputs.affinity-nix.packages.x86_64-linux.publisher
      ];

      sessionVariables = with pkgs; {
        BROWSER = "${vivaldi}/bin/vivaldi";
        EDITOR  = "${helix}/bin/hx";
        VISUAL  = "${helix}/bin/hx";
      };
    };

    programs = {
      ghostty.enableZshIntegration = config.programs.zsh.enable;
      yazi.enableZshIntegration    = config.programs.zsh.enable;
    };
  };
}
