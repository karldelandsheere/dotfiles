###############################################################################
#
# Additional setup for AMD flavoured devices
#
###############################################################################

{ inputs, self, ... }:
{
  flake.modules.nixos.core_amd = { lib, config, ... }:
  {
    config = {
      hardware.cpu.amd.updateMicrocode = true;
    };
  };
}
