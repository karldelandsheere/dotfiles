###############################################################################
#
# Helix > Vim imho. ;)
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.helix = { config, osConfig, lib, pkgs, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    config = {
      programs.helix = {
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

      home.sessionVariables = with pkgs; {
        EDITOR  = "${helix}/bin/hx";
        VISUAL  = "${helix}/bin/hx";
      };
    };
  };
}
