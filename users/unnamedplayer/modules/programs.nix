#############################################################################
#
# All programs related stuff that is not mandatory on every host
# plus the configs that are /home/username related.
# Otherwise, it will probably be in system/modules/programs
# 
#############################################################################
  
{ config, pkgs, osConfig, lib, inputs, ... }: let
  cfg = osConfig.nouveauxParadigmes;
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
        basalt                 # @todo check back in a couple months
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
        jellyfin-tui           # TUI client for Jellyfin Media Server
        mpv                    # Video player
        progress               # Follow the progression of any command
        pure-prompt
        scooter                # Directory wide search & replace
        # termusic               # @todo Test and config that
        tmux                   # Terminal multiplexer
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
        inkscape               # Vector graphics editor
        # mullvad-browser        # Highly privacy focused browser
        # opencloud-desktop
        openscad               # Code based CAD
        prusa-slicer           # Slicer for my Prusa printers
        rustdesk-flutter       # Open source Remote Desktop (like AnyDesk or TimeViewer)
        # qbittorrent
        signal-desktop         # Privacy focused messaging
        vivaldi                # Privacy focused browser
        # vlc                  # Replaced by mpv (tty video player)
      ]

       # GUI and unfree programs
       ++ lib.lists.optionals ( cfg.gui.enable && osConfig.nixpkgs.config.allowUnfree ) [
        obsidian               # Markdown note taking app
        termius                # Cross-platform SSH client
      ];

      sessionVariables = with pkgs; {
        BROWSER = "${vivaldi}/bin/vivaldi";
        EDITOR  = "${helix}/bin/hx";
        VISUAL  = "${helix}/bin/hx";
      };
    };

    programs = {
      git = {                # Git ID's and signing options
        enable = true;
        settings.user = {
          name  = "Karl";
          email = "karl@delandsheere.be";
        };

        signing = {
          key           = "D4EFAA4CD5AE64F4";
          signByDefault = true;
        };
      };

      zed-editor = {
        enable       = true;
        extensions   = [ "html" "nix" "php" "xml" ];
        userSettings = {
          base_keymap      = "VSCode";
          buffer_font_size = 16;
          disable_ai       = true;
          helix_mode       = true;
          icon_theme       = {
            mode = "dark";
            dark = "Zed (Default)";
          };
          telemetry        = {
            diagnostics = false;
            metrics     = false;
          };
          theme            = {
            mode = "dark";
            dark = "One Dark";
          };
          ui_font_size     = 16;
        };
      };

      zsh = {
        enable = true;
        initContent = ''
          autoload -U promptinit; promptinit
          zstyle ':prompt:pure:path' color red
          zstyle ':prompt:pure:prompt:*' color red
          zstyle ':prompt:pure:git:stash' show yes 
          prompt pure
        '';
      };

      ghostty.enableZshIntegration  = true;
      yazi.enableZshIntegration     = true;
    };
  };
}
