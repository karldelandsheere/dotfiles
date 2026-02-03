###############################################################################
#
# Additional options for AMD
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core_amd = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      hardware.cpu.amd.updateMicrocode = true;
    };
  };
}
