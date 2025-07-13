{ config, ... }:
{
  # Filesystem structure
  # Options for what's already in hardware-configuration.nix
  # All needed for the impermanence and hibernation modules
  # -------------------------------------------------------
  config = {
    fileSystems = {
      "/boot" = {
        fsType = "vfat";
      };

      "/" = {
        fsType = "btrfs";
        options = [ "subvol=root" "compress=zstd" "noatime" ];
      };

      "/home" = {
        fsType = "btrfs";
        neededForBoot = true;
        options = [ "subvol=home/active" "compress=zstd" "noatime" ];
      };

      "/home/.snapshots" = {
        fsType = "btrfs";
        options = [ "subvol=home/snapshots" "compress=zstd" "noatime" ];
      };

      "/nix" = {
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
      };

      "/persist" = {
        fsType = "btrfs";
        neededForBoot = true;
        options = [ "subvol=persist/active" "compress=zstd" "noatime" ];
      };

      "/persist/.snapshots" = {
        fsType = "btrfs";
        neededForBoot = true;
        options = [ "subvol=persist/snapshots" "compress=zstd" "noatime" ];
      };

      "/var/local" = {
        fsType = "btrfs";
        options = [ "subvol=var_local/active" "compress=zstd" "noatime" ];
      };

      "/var/local/.snapshots" = {
        fsType = "btrfs";
        options = [ "subvol=var_local/snapshots" "compress=zstd" "noatime" ];
      };

      "/var/log" = {
        fsType = "btrfs";
        neededForBoot = true;
        options = [ "subvol=var_log" "compress=zstd" "noatime" ];
      };

      "/swap" = {
        fsType = "btrfs";
        options = [ "subvol=swap" "compress=none" "noatime" ];
      };
    };
  };
}
