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
    withDesktop = config.features.desktop.enable;
  in
  {
    config = {
      environment.systemPackages = with pkgs; [
        flac            # FLAC codecs
      ] ++ lib.lists.optionals withDesktop [ pwvucontrol ];

      services = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = withDesktop;
          };
          pulse.enable = withDesktop;
          wireplumber.enable = true;
        };
      };
    };
  };
}
