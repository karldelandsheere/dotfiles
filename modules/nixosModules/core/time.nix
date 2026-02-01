###############################################################################
#
# Time, the ultimate frontier.
#
# It's a bit overkill to have a whole file for just that but I guess more
#   will come. Only time will tell...
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    options.nouveauxParadigmes.timeZone = lib.mkOption {
        type        = lib.types.str;
        default     = "Europe/Brussels";
        description = "Host's time zone. Defaults to Europe/Brussels";
    };
  
    config = {
      time.timeZone = cfg.timeZone;
    };
  };
}

