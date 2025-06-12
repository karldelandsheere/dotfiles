{ pkgs, ... }:

{
  security.rtkit.enable = true;
  hardware.alsa.enable = true;

  # services.pipewire = {
		# enable = true;
		# alsa.enable = true;
		# pulse.enable = true;
  #   wireplumber.enable = true;
  # };

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];
}
