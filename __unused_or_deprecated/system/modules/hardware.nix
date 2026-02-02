###############################################################################
#
# Hardware related stuff, like bluetooth, graphics, etc
# 
###############################################################################

{ config, lib, pkgs, ... }:
{
  # Related options and default values definition
  # options.nouveauxParadigmes = {
  #   system = lib.mkOption { # @todo Is that used at all?
  #     type        = lib.types.str;
  #     default     = "x86_64-linux";
  #     description = "What is the system architecture? Defaults to x86_64-linux.";
  #   };

  #   cpuFlavor = lib.mkOption {
  #     type        = lib.types.str;
  #     default     = "";
  #     description = "amd or intel?";
  #   };
  # };


  config = {
    # System-wide packages needed to control hardware
    environment.systemPackages = with pkgs; [
      # pwvucontrol
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.cpuFlavor == "amd" ) [
      # pkgs.microcode-amd
    ] ++ lib.lists.optionals ( config.nouveauxParadigmes.cpuFlavor == "intel" ) [
      pkgs.microcode-intel
    ];


    # Harware activation and settings
    hardware = {
      enableAllFirmware = true;

      # Graphics
      # graphics = {
      #   enable      = true;
      #   enable32Bit = true;
      # };
    };


    # Hardware services
    services = {
      # # Sound
      # pipewire = {
      #   enable = true;
      #   alsa   = {
      #     enable       = true;
      #     support32Bit = true;
      #   };
      #   pulse.enable       = true;
      #   wireplumber.enable = true;
      # };
      # pulseaudio.enable = false;

      # What exactly?
      udisks2.enable = true; # What was it again?
    };
  };
}
