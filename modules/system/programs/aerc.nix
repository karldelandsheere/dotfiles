###############################################################################
#
# aerc is a tty e-mail client.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.homeModules.aerc = { config, osConfig, lib, pkgs, ... }:
  {
    config = {
      programs = {
        aerc = {
          enable = true;
        };
      };
    };
  };
}
