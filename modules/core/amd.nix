###############################################################################
#
# Additional setup for AMD flavoured devices
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.core_amd = { lib, config, ...}:
  {
    config = {
      hardware.cpu.amd.updateMicrocode = true;
    };
  };
}
