###############################################################################
#
# Zed, minimal code editor.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.zed-editor = { config, osConfig, lib, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      programs.zed-editor = {
        enable = true;
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

      # Ressources to persist
      home.persistence."/persist" =
        lib.mkIf osConfig.features.impermanence.enable {
          directories = [ ".config/zed" ];
        };
    };
  };
}
