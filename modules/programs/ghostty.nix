###############################################################################
#
# Ghostty, terminal emulator.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.ghostty = { config, osConfig, lib, ... }:
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
