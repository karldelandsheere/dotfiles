###############################################################################
#
# Ghostty, terminal emulator.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.ghostty = { config, osConfig, lib, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    config = lib.mkIf cfg.gui.enable {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
