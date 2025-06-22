{ ... }:

{
  # Filesystem structure
  # --------------------
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
      neededForBoot = true;
      options = [ "subvol=swap" "compress=none" "noatime" ];
    };
  };


  # initrd.systemd = {
  #   # Reset root on each reboot
  #   # -------------------------
  #   services.rollback = {
  #     description = "Rollback BTRFS root subvolume to a pristine state";
  #     wantedBy = [
  #       "initrd.target"
  #     ];
  #     before = [
  #       "sysroot.mount"
  #     ];
  #     unitConfig.DefaultDependencies = "no";
  #     serviceConfig.Type = "oneshot";
  #     script = ''
  #       mkdir -p /mnt
  #       mount -o subvol=/ /dev/nvme0n1p2 /mnt
  #       btrfs subvolume list -o /mnt/root | cut -f9 -d' ' |
  #       while read subvolume; do
  #         echo "Deleting /$subvolume subvolume"
  #         btrfs subvolume delete "/mnt/$subvolume"
  #       done &&
  #       echo "Deleting /root subvolume" &&
  #       btrfs subvolume delete /mnt/root
  #       echo "Restoring blank /root subvolume"
  #       btrfs subvolume snapshot /mnt/root-blank /mnt/root
  #       umount /mnt
  #     '';
  #   };


  # Stuff that needs to persist
  # ---------------------------
  # services.persisted-files = {
  #   description = "Hard-link persisted files from /persist";
  #   wantedBy = [
  #     "initrd.target"
  #   ];
  #   after = [
  #     "sysroot.mount"
  #   ];
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     mkdir -p /sysroot/etc/
  #     ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
  #     '';
  # };


  # environment.persistence."/persist" = { 
  #   hideMounts = true ; 
    
  #   directories = [
  #     "/etc/nixos"                       # NixOS
  #     "/etc/NetworkManager"              # NetworkManager
  #     "/var/lib/NetworkManager"
  #     "/var/lib/bluetooth"               # Bluetooth
  # #     "/var/lib/docker"                  # Docker

      

  #   ];
    
  #   files = [   
  # #     "/etc/ssh/ssh_host_*"                 # SSH
  #     "/etc/machine-id"                     # Needed for SystemD Journal
  #     "/var/lib/NetworkManager/secret_key"  # Network Manager
  #     "/var/lib/NetworkManager/seen-bssids" # Network Manager
  #     "/var/lib/NetworkManager/timestamps"  # Network Manager
  #     { file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; } # Nix
  #   ];
  # };


  # Symlinks to keep important files on /persist
  # --------------------------------------------
  environment.etc = {
    "machine-id".source = "/persist/etc/machine-id";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";

  };
   
}
