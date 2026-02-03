###############################################################################
#
# Swap related config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    options.nouveauxParadigmes = {
      swapSize = lib.mkOption {
        type        = lib.types.int;
        default     = lib.mkDefault 8*1024; # 8GB is a good default value, right?
        description = "Size of swapfile. Defaults to 8*1024.";
      };
    };
  
    config = {
      fileSystems."/swap".options = [ "compress=none" "noatime" ];

      swapDevices = [ {
        device = "/swap/swapfile";
        size = cfg.swapSize;
      } ];
    };
  };
}

