###############################################################################
#
# Thunderbird is an email, rss/atom, IM, ... client.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.thunderbird = { config, osConfig, lib, pkgs, ... }: let
  in
  {
    config = lib.mkIf osConfig.features.desktop.enable {
      programs = {
        thunderbird = {
          enable = true;
          profiles = {};
          settings = {};
        };
      };
    };
  };
}
