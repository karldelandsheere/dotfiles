###############################################################################
#
# Audio generic config.
#
# For host|user specific options, go to host|user's config.
#
###############################################################################

{ inputs, self, ... }:
{
  flake.nixosModules.audio = { lib, config, pkgs, ...}: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      environment.systemPackages = with pkgs; [
        flac            # FLAC codecs
        pwvucontrol
      ];

      services = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true; # Should I move that one to host?
          };
          pulse.enable = true;
          wireplumber.enable = true;
        };
      };
    };
  };
}
