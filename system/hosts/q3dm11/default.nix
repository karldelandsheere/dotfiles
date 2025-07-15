{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../default.nix
  ];

  config = {
    # Custom options
    # --------------
    nouveauxParadigmes = {
      hostname            = "q3dm11";
      cpuFlavor           = "intel";
      rootDisk            = "/dev/sda";
      encryption.enable   = true;
      impermanence.enable = true;
      gui.enable          = false; # full tty on this setup
      stateVersion        = "23.11";
    };

    # Host specific packages
    # ----------------------
    environment.systemPackages = with pkgs; [
      # microcode-intel
    ];
  };
}
