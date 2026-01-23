#############################################################################
#
# All programs related stuff that is not mandatory on every host
# plus the configs that are /home/username related.
# Otherwise, it will probably be in system/modules/programs
#
# Next steps:
# -----------
# - @todo Find a way to display images in Gurk
# 
#############################################################################
  
{ config, pkgs, osConfig, lib, inputs, ... }: let
  cfg = osConfig.nouveauxParadigmes;
in
{
  config = {
    # # this allows you to access `unstable` anywhere in your config
    # # https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # #
    # _module.args.pkgsUnstable = import inputs.unstable {
    #   inherit (pkgs.stdenv.hostPlatform) system;
    #   inherit (config.nixpkgs) config;
    # };
    nixpkgs.overlays = [ (final: _: {
      # this allows you to access `pkgs.unstable` anywhere in your config
      unstable = import inputs.unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    } ) ];
    
    home = {
      # Programs that don't need a lot of config
      # ----------------------------------------
      packages = ( with pkgs; [
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
        pure-prompt            # Still on the fence with this one
        scooter                # Directory wide search & replace
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
      ] )

      ++ [ pkgs.unstable.gurk-rs ];

      sessionVariables = with pkgs; {
        BROWSER = "${vivaldi}/bin/vivaldi";
        EDITOR  = "${helix}/bin/hx";
        VISUAL  = "${helix}/bin/hx";
      };


      # Config files for all those wonderful apps
      # -----------------------------------------
      file = lib.listToAttrs ( map ( path: {
        name  = ".config/${path}";
        value = { source = ../../../config/everywhere/${path}; };
      } ) [
        "bottom/bottom.toml"
        "fastfetch/config.jsonc"
        # "gurk/gurk.toml"
        "helix/config.toml"
        "yazi/theme.toml" # Do I keep this though?
        "yazi/yazi.toml"
      ] );
    };

    programs = {
      git = {      # Git ID's and signing options
        enable = true;
        settings.user = {
          name  = "Karl";
          email = "karl@delandsheere.be"; };

        signing = {
          key           = "D4EFAA4CD5AE64F4";
          signByDefault = true; };
      };


      niri.settings = {
        screenshot-path = "~/Data/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
        spawn-at-startup = [
          { argv = ["ghostty"]; }
        ];

        # Binds
        # -----
        binds = {
          "Mod+Ctrl+T".action.spawn = "ghostty";
          "Ctrl+Alt+W".action.spawn = [ "sh" "-c" "loginctl terminate-user $USER" ];
        };

        # Workspaces and windows rules
        # ----------------------------
        workspaces = {
          "01-daily"    = { name = "daily"; };
          "02-tty"      = { name = "tty"; };
          "03-web"      = { name = "web"; };
          "04-dev"      = { name = "dev"; };
          "05-3d"       = { name = "3d"; };
          "06-graphics" = { name = "graphics"; };
          "07-stuff"    = { name = "stuff"; };
        };

        window-rules = [
          { # Messaging apps, planning, etc are daily apps
            matches           = [
              { app-id = "signal"; }
              { title  = "gurk"; }
            ];
            open-on-workspace = "daily"; }

          { # All tty apps run in Ghostty that are not assigned somewhere else
            matches           = [ { app-id = "com.mitchellh.ghostty"; } ];
            opacity           = 0.85;
            open-on-workspace = "tty"; }

          { # Internet browser, etc.
            matches           = [ { app-id = "vivaldi"; } ];
            open-maximized    = true;
            open-on-workspace = "web"; }

          { # Code editor, SSH clients, etc.
            matches           = [
              { app-id = "dev.zed.Zed"; }
              { app-id = "Termius"; } ];
            opacity           = 0.85;
            open-maximized    = true;
            open-on-workspace = "dev"; }

          { # All apps regarding 3D modeling, printing, ...
            matches           = [
              { app-id = "blender"; }
              { app-id = "org.openscad."; }
              { app-id = "PrusaSlicer"; } ];
            open-maximized    = true;
            open-on-workspace = "3d"; }

          { # Graphic design apps
            matches           = [ { app-id = "inkscape"; } ];
            open-maximized    = true;
            open-on-workspace = "graphics"; }

          { # Stuff like journaling, documents, file explorer, etc.
            matches           = [
              { app-id = "desktop.opencloud.eu."; }
              { app-id = "nemo"; }
              { app-id = "obsidian"; } ];
            open-maximized    = true;
            open-on-workspace = "stuff"; }
        ];
      };

      # noctalia-shell.settings = {
      #   general.avatarImage      = "/home/unnamedplayer/.face";
      #   # wallpaper.directory      = "/home/unnamedplayer/Pictures/Wallpapers";
      # };

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
