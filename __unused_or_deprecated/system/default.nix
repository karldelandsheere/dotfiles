###############################################################################
#
# This is the common part for all systems config.
#
# The system-wide options and their default values are defined here,
# as the parts that are too small for having their own files.
#
###############################################################################

{ config, lib, pkgs, ... }: let
  cfg = config.nouveauxParadigmes;
  users = [ "unnamedplayer" ]; # @todo Repair the users provisioning
in
{
  config = {
    services = {
      # If the whole system is encrypted and password protected at boot,
      # and there's only one user, no need to type a second login right after
      getty = lib.mkIf ( cfg.encryption.enable && lib.length users == 1 ) {
        autologinUser = "${lib.head users}";
      };
    };
  };
}
