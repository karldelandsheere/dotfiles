###############################################################################
#
# Additional options to Power management for AMD
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.powersave_amd = { lib, config, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      # https://wiki.cachyos.org/configuration/general_system_tweaks/#enable-rcu-lazy
      boot.kernelParams = [ "rcutree.enable_rcu_lazy=1" ];

      services.auto-epp = {
        enable = true;
        settings.Settings = {
          epp_state_for_AC  = "balance_performance";
          epp_state_for_BAT = "power";
        };
      };
    };
  };
}
