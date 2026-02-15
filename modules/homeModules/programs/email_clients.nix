###############################################################################
#
# E-mail stuff.
#
# This module enables clients: aerc (tty) and thunderbird.
#
# @todo Move the profiles out of this
#       in order to make this module more reusable.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.email_clients = { config, osConfig, lib, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    config = {
      programs = {
        # aerc = {
        #   enable = false;
        # };

        # thunderbird = lib.mkIf cfg.gui.enable {
        #   enable = false; # For now
        #   profiles = {};
        #   settings = {};
        # };
      };
    };
  };
}
