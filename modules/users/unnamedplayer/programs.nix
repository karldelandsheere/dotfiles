###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
in
{
  flake.homeModules.${username} = { config, pkgs, osConfig, lib, ... }: let
    withDesktop = osConfig.features.desktop.enable;
  in
  {
    imports = [
      # Core utils
      self.homeModules.bitwarden
      self.homeModules.ghostty
      self.homeModules.mullvad-browser

      # Comms
      # self.homeModules.aerc
      # self.homeModules.thunderbird
      self.homeModules.signal-desktop
      # self.homeModules.gurk-rs
      # self.homeModules.iamb

      # Organizing and stuff
      # self.homeModules.basalt
      self.homeModules.obsidian
      # self.homeModules.calcurse

      # Dev and work stuff
      self.homeModules.rustdesk
      self.homeModules.termius
      self.homeModules.zed-editor

      # 3D stuff
      self.homeModules.openscad
      self.homeModules.bambu-studio
      self.homeModules.prusa-slicer

      # Media
      self.homeModules.jellyfin-tui
      self.homeModules.mpv
      # self.homeModules.vlc
    ];
    
    config = {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "obsidian"
        "termius"
      ];

      programs.niri.settings = lib.mkIf withDesktop {
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
    };
  };
}
