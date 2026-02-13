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
          ghostty                # Terminal emulator
          inkscape               # Vector graphics editor
          mullvad-browser        # Highly privacy focused browser
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
        bottom = { # Process/system monitor
          enable = true;
          settings = {
            styles = {
              battery = {
                high_battery_color = "#a6e3a1";
                low_battery_color = "#f38ba8";
                medium_battery_color = "#f9e2af";
              };
              cpu = {
                all_entry_color = "#f5e0dc";
                avg_entry_color = "#eba0ac";
                cpu_core_colors = [
                  "#f38ba8"
                  "#fab387"
                  "#f9e2af"
                  "#a6e3a1"
                  "#74c7ec"
                  "#cba6f7"
                ];
              };
              graphs = {
                graph_color = "#a6adc8";
                legend_text = { color = "#a6adc8"; };
              };
              memory = {
                arc_color = "#89dceb";
                cache_color = "#f38ba8";
                gpu_colors = [
                  "#74c7ec"
                  "#cba6f7"
                  "#f38ba8"
                  "#fab387"
                  "#f9e2af"
                  "#a6e3a1"
                ];
                ram_color = "#a6e3a1";
                swap_color = "#fab387";
              };
              network = {
                rx_color = "#a6e3a1";
                tx_color = "#f38ba8";
                rx_total_color = "#89dceb";
                tx_total_color = "#a6e3a1";
              };
              tables = {
                headers = { color = "#f5e0dc"; };
              };
              widgets = {
                disabled_text = { color = "#1e1e2e"; };
                selected_border_color = "#f5c2e7";
                selected_text = {
                  bg_color = "#cba6f7";
                  color = "#11111b";
                };
                text = { color = "#cdd6f4"; };
                widget_title = { color = "#f2cdcd"; };
              };
            };
          };
        };

        fastfetch = { # Am I a cool already?
          enable = true;
          settings = let
            keyColor = "#f5c2e7";

            sectionTitle = name: " [---- ${name} ----] ";

            sectionEnd = " ────────────────────── ";

            colored = type: { inherit type keyColor; };
          in
          {
            display = {
              constants = [ "─────────────────" ];
              key = { paddingLeft = 2; type = "icon"; };
              separator = "  ";
            };

            logo = {
              color = {
                "1" = "#a6adc8";
                "2" = "#9399b2";
              };
              height = 20;
              padding = { left = 2; right = 2; };

              width = 25;
            };

            modules = [
              { type = "custom"; format = sectionTitle "Hardware Information"; }

              (colored "host")
              (colored "cpu")
              (colored "gpu")
              (colored "disk")
              (colored "memory")
              (colored "swap")
              (colored "display")

              { type = "custom"; format = sectionEnd; }

              { type = "custom"; format = ""; }

              { type = "custom"; format = sectionTitle "Software Information"; }

              (colored "os")
              (colored "kernel")
              (colored "wm")
              (colored "shell")
              (colored "terminal")
              (colored "font")
              (colored "theme")
              (colored "icons")
              (colored "packages")
              (colored "uptime")
              (colored "locale")

              { type = "custom"; format = sectionEnd; }

              {
                paddingLeft = 2;
                symbol = "circle";
                type = "colors";
              }
            ];
          };
        };

        ghostty.enableZshIntegration  = true;

        git = { # Git ID's and signing options
          enable = true;
          settings.user = {
            name  = "Karl";
            email = "karl@delandsheere.be"; };

          signing = {
            key           = "D4EFAA4CD5AE64F4";
            signByDefault = true; };
        };

        gurk-rs = { # Signal client for the tty. @todo fix images and transfer
          enable = false; # for now
          package = pkgs.unstable.gurk-rs;
          settings = {
            bell = true;
            colored_messages = false;
            data_dir = "${config.home.homeDirectory}/.local/share/gurk";
            default_keybindings = true;
            first_name_only = false;
            keybindings =  {};
            show_receipts = true;
            user = { # @todo Move this to secrets
              name = "Karl";
              phone_number = "+32498139866";
            };
          };
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

        iamb = { # Element/Synapse client
          enable = false; # for now
          settings = {
            default_profile = "dimeritium"; #config.home.username;
            layout = {
              style = "config";
              tabs = [
                { window = "iamb://dms"; }
                { window = "iamb://rooms"; }
              ];
            };
            profiles = { # @todo Move this to secrets
              "dimeritium" = {
                url = "https://matrix.dimeritium.com";
                user_id = "@karldelandsheere:matrix.dimeritium.com";
              };
            };
            settings = {
              image_preview = {
                protocol.type = "sixel";
                size = {
                  height = 20;
                  width = 66;
                };
              };
              log_level = "warn";
              notifications.enabled = true;
              sort = {
                rooms = [ "unread" "favorite" "name" "lowpriority" ];
                members = [ "id" "power" ];
              };
              user_gutter_width = 30;
              username_display = "username";
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

        yazi = { # A really cool CLI file explorer
          enable = true;
          enableZshIntegration = true;

          settings = {
            yazi = {
              confirm = {
                delete_offset = [ 0 0 70 20 ];
                delete_origin = "center";
                delete_title = "Permanently delete {n} selected file{s}?";

                overwrite_content = "Will overwrite the following file:";
                overwrite_offset = [ 0 0 50 15 ];
                overwrite_origin = "center";
                overwrite_title = "Overwrite file?";

                quit_content = "The following tasks are still running, are you sure you want to quit?";
                quit_offset = [ 0 0 50 15 ];
                quit_origin = "center";
                quit_title = "Quit?";

                trash_offset = [ 0 0 70 20 ];
                trash_origin = "center";
                trash_title = "Trash {n} selected file{s}?";
              };

              input = {
                cd_offset = [ 0 2 50 3 ];
                cd_origin = "top-center";
                cd_title = "Change directory:";

                create_offset = [ 0 2 50 3 ];
                create_origin = "top-center";
                create_title = [ "Create:" "Create (dir):" ];

                cursor_blink = false;

                filter_offset = [ 0 2 50 3 ];
                filter_origin = "top-center";
                filter_title = "Filter:";

                find_offset = [ 0 2 50 3 ];
                find_origin = "top-center";
                find_title = [ "Find next:" "Find previous:" ];

                rename_offset = [ 0 1 50 3 ];
                rename_origin = "hovered";
                rename_title = "Rename:";

                search_offset = [ 0 2 50 3 ];
                search_origin = "top-center";
                search_title = "Search via {n}:";

                shell_offset = [ 0 2 50 3 ];
                shell_origin = "top-center";
                shell_title = [ "Shell:" "Shell (block):" ];
              };

              mgr = {
                linemode = "none";
                mouse_events = [ "click" "scroll" ];
                ratio = [ 1 4 3 ];
                scrolloff = 5;
                show_hidden = true;
                show_symlink = true;
                sort_by = "alphabetical";
                sort_dir_first = true;
                sort_reverse = false;
                sort_sensitive = false;
                sort_translit = false;
                title_format = "Yazi: {cwd}";
              };

              open.rules = [
                { name = "*/"; use = [ "edit" "open" "reveal" ]; }
                { mime = "text/*"; use = [ "edit" "reveal" ]; }
                { mime = "image/*"; use = [ "open" "reveal" ]; }
                { mime = "{audio,video}/*"; use = [ "play" "reveal" ]; }
                { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
                  use = [ "extract" "reveal" ]; }
                { mime = "application/{json,ndjson}"; use = [ "edit" "reveal" ]; }
                { mime = "*/javascript"; use = [ "edit" "reveal" ]; }
                { mime = "inode/empty"; use = [ "edit" "reveal" ]; }
                { name = "*"; use = [ "open" "reveal" ]; }
              ];

              opener = {
                edit = [
                  { run = ''${EDITOR:-vi} "$@"''; desc = "$EDITOR"; block = true; for = "unix"; }
                ];

                extract = [
                  { run = ''ya pub extract --list "$@"''; desc = "Extract here"; for = "unix"; }
                ];

                open = [
                  { run = ''xdg-open "$1"''; desc = "Open"; for = "linux"; }
                  { run = ''open "$@"''; desc = "Open"; for = "macos"; }
                ];

                play = [
                  { run = ''mpv --force-window "$@"''; orphan = true; for = "unix"; }
                  { run = ''mediainfo "$1"; echo "Press enter to exit"; read _''; block = true; desc = "Show media info"; for = "unix"; }
                ];

                reveal = [
                  { run = ''xdg-open "$(dirname "$1")"''; desc = "Reveal"; for = "linux"; }
                  { run = ''open -R "$1"''; desc = "Reveal"; for = "macos"; }
                  { run = ''clear; exiftool "$1"; echo "Press enter to exit"; read _''; block = true; desc = "Show EXIF"; for = "unix"; }
                ];
              };

              pick = {
                open_offset = [ 0 1 50 7 ];
                open_origin = "hovered";
                open_title = "Open with:";
              };

              plugin = {
                fetchers = [
                  { id = "mime"; name = "*"; prio = "high"; run = "mime"; }
                ];

                preloaders = [
                  { mime = "image/{avif,hei?,jxl}"; run = "magick"; }
                  { mime = "image/svg+xml"; run = "svg"; }
                  { mime = "image/*"; run = "image"; }
                  { mime = "video/*"; run = "video"; }
                  { mime = "application/pdf"; run = "pdf"; }
                  { mime = "font/*"; run = "font"; }
                  { mime = "application/ms-opentype"; run = "font"; }
                ];

                previewers = [
                  { name = "*/"; run = "folder"; }
                  { mime = "text/*"; run = "code"; }
                  { mime = "application/{mbox,javascript,wine-extension-ini}"; run = "code"; }
                  { mime = "application/{json,ndjson}"; run = "json"; }
                  { mime = "image/{avif,hei?,jxl}"; run = "magick"; }
                  { mime = "image/svg+xml"; run = "svg"; }
                  { mime = "image/*"; run = "image"; }
                  { mime = "video/*"; run = "video"; }
                  { mime = "application/pdf"; run = "pdf"; }
                  { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"; run = "archive"; }
                  { mime = "application/{debian*-package,redhat-package-manager,rpm,android.package-archive}"; run = "archive"; }
                  { name = "*.{AppImage,appimage}"; run = "archive"; }
                  { mime = "application/{iso9660-image,qemu-disk,ms-wim,apple-diskimage}"; run = "archive"; }
                  { mime = "application/virtualbox-{vhd,vhdx}"; run = "archive"; }
                  { name = "*.{img,fat,ext,ext2,ext3,ext4,squashfs,ntfs,hfs,hfsx}"; run = "archive"; }
                  { mime = "font/*"; run = "font"; }
                  { mime = "application/ms-opentype"; run = "font"; }
                  { mime = "inode/empty"; run = "empty"; }
                  { name = "*"; run = "file"; }
                ];

                spotters = [
                  { name = "*/"; run = "folder"; }
                  { mime = "text/*"; run = "code"; }
                  { mime = "application/{mbox,javascript,wine-extension-ini}"; run = "code"; }
                  { mime = "image/{avif,hei?,jxl}"; run = "magick"; }
                  { mime = "image/svg+xml"; run = "svg"; }
                  { mime = "image/*"; run = "image"; }
                  { mime = "video/*"; run = "video"; }
                  { name = "*"; run = "file"; }
                ];
              };

              preview = {
                cache_dir = "";
                image_delay = 30;
                image_filter = "triangle";
                image_quality = 75;
                max_height = 900;
                max_width = 600;
                tab_size = 2;
                ueberzug_offset = [ 0 0 0 0 ];
                ueberzug_scale = 1;
                wrap = "no";
              };

              tasks = {
                bizarre_retry = 3;
                image_alloc = 536870912;
                image_bound = [ 5000 5000 ];
                macro_workers = 10;
                micro_workers = 10;
                suppress_preload = false;
              };

              which = {
                sort_by = "none";
                sort_reverse = false;
                sort_sensitive = false;
                sort_translit = false;
              };
            };
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
      };
    };
  };
}
