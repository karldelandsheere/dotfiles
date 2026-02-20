###############################################################################
#
# Zed, minimal code editor.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.zed-editor = { config, osConfig, lib, ... }: let
    withDesktop = osConfig.features.desktop.enable;
    withImpermanence = osConfig.features.impermanence.enable;
  in
  {
    config = lib.mkIf withDesktop {
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

      # What data should persist
      home.persistence."/persist" = lib.mkIf withImpermanence {
        directories = [ ".config/zed" ];
      };
    };
  };
}
