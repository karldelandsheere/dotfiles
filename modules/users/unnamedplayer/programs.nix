###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
in
{
  flake.homeModules.${username} = { config, pkgs, osConfig, lib, inputs, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    imports = [
      self.homeModules.bottom
      self.homeModules.fastfetch
      self.homeModules.matrix_clients
      self.homeModules.signal
      self.homeModules.yazi
    ];
    
    config = {
      home = {
        packages = ( with pkgs; [
          # TUI/CLI programs
          # ----------------
          # aerc                   # Email client
          # basalt                 # @todo check back in a couple months
          bitwarden-cli          # Easy access to my vault in tty
          # calcurse               # CalDav client
          cmatrix                # Yeah, I know... like the cool kids
          curl
          exiftool
          ffmpeg
          jellyfin-tui           # TUI client for Jellyfin Media Server
          mpv                    # Video player
          progress               # Follow the progression of any command
          pure-prompt            # Still on the fence with this one
          scooter                # Directory wide search & replace
          tmux                   # Terminal multiplexer
          tree                   # Kinda ls but as a tree
          ueberzugpp             # Terminal image viewer (needed for yazi)
          yt-dlp                 # Youtube downloader
        ]

        # GUI programs
        ++ lib.lists.optionals ( cfg.gui.enable ) [
          bambu-studio           # Slicer for my Bambu printers
          bitwarden-desktop      # Passwords & stuff
          # blender
          inkscape               # Vector graphics editor
          mullvad-browser        # Highly privacy focused browser
          # opencloud-desktop
          openscad               # Code based CAD
          prusa-slicer           # Slicer for my Prusa printers
          rustdesk-flutter       # Open source Remote Desktop (like AnyDesk or TimeViewer)
          # qbittorrent
          # vlc                  # Replaced by mpv (tty video player)
        ]

        # GUI and unfree programs
        ++ lib.lists.optionals ( cfg.gui.enable && osConfig.nixpkgs.config.allowUnfree ) [
          obsidian               # Markdown note taking app
          termius                # Cross-platform SSH client
        ] );

        shellAliases = {
          dots = "cd ${cfg.dotfiles}";
          keycodes = "xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'";

          # Git shortcuts for the lazy ass I am
          ga    = "git add";
          gaa   = "git add --all";
          gaacm = "git add --all && git commit -S -m";
          gb    = "git branch";
          gc    = "git commit -S";
          gch   = "git checkout";
          gchb  = "git checkout -b";
          gcl   = "git clone";
          gcm   = "git commit -S -m";
          gd    = "git diff";
          gm    = "git merge";
          gpl   = "git pull";
          gplo  = "git pull origin";
          gps   = "git push";
          gpso  = "git push origin";
          gs    = "git status";
        };

        sessionVariables = with pkgs; {
          BROWSER = "${mullvad-browser}/bin/mullvad-browser";
          EDITOR  = "${helix}/bin/hx";
          VISUAL  = "${helix}/bin/hx";
        };
      };

      programs = {
        ghostty = {
          enable = true;
          enableZshIntegration = config.programs.zsh.enable;
        };

        git = { # Git ID's and signing options
          enable = true;
          settings.user = {
            name  = "Karl";
            email = "karl@delandsheere.be"; };

          signing = {
            key           = "D4EFAA4CD5AE64F4";
            signByDefault = true; };
        };

        helix = { # Helix > Vim imho
          enable = true;
          settings = {
            theme = "catppuccin_mocha";
            editor = {
              cursorline = true;
              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };
              line-number = "relative";
              middle-click-paste = false;
              mouse = true;
            };
          };
        };

        niri.settings = {
          screenshot-path = "~/Data/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

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
              matches           = [
                { app-id = "vivaldi"; }
                { app-id = "Mullvad Browser"; } ];
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
                { app-id = "obsidian"; } ];
              open-maximized    = true;
              open-on-workspace = "stuff"; }
          ];
        };

        thunderbird = {
          enable = false; # For now
          profiles = {};
          settings = {};
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
      };
    };
  };
}
