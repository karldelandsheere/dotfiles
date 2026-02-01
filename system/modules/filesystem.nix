###############################################################################
#
# Filesystem structure, swap devices, ...
# Mostly options for what's already in hardware-configuration.nix
#
# All needed for
#   - impermanence (./impermanence.nix) and
#   - hibernation (./power-management.nix)
# 
###############################################################################

{ config, lib, ... }:
{
  # Related options and default values definition
  options.nouveauxParadigmes = {
    rootDisk = lib.mkOption {
      type        = lib.types.str;
      default     = "";
      description = "Which is the root disk? No default";
    };
    
    swapSize = lib.mkOption {
      type        = lib.types.int;
      default     = 8*1024; # 8GB is a good default value, right?
      description = "Size of swapfile. Defaults to 8*1024. \
                     If hibernation is enabled, \
                     it should be at least the size of your RAM.";
    };
  };

  
  config = {
    # Volumes
    fileSystems = {
      "/" = {
        options = [ "subvol=root" "compress=zstd" "noatime" ];
      };

      "/home" = {
        neededForBoot = true;
        options       = [ "subvol=home/active" "compress=zstd" "noatime" ];
      };

      "/home/.snapshots" = {
        options = [ "subvol=home/snapshots" "compress=zstd" "noatime" ];
      };

      "/nix" = {
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
      };

      "/persist" = {
        neededForBoot = true;
        options       = [ "subvol=persist/active" "compress=zstd" "noatime" ];
      };

      "/persist/.snapshots" = {
        neededForBoot = true;
        options       = [ "subvol=persist/snapshots" "compress=zstd" "noatime" ];
      };

      "/var/local" = {
        options = [ "subvol=var_local/active" "compress=zstd" "noatime" ];
      };

      "/var/local/.snapshots" = {
        options = [ "subvol=var_local/snapshots" "compress=zstd" "noatime" ];
      };

      "/var/log" = {
        neededForBoot = true;
        options       = [ "subvol=var_log" "compress=zstd" "noatime" ];
      };

      "/swap" = {
        options = [ "subvol=swap" "compress=none" "noatime" ];
      };
    };


    # Swap, I use a file over a partition
    # -----------------------------------
    swapDevices = [ {
      device = "/swap/swapfile";
      size   = config.nouveauxParadigmes.swapSize;
    } ];
  };
}
