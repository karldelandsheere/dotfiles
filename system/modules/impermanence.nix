{ inputs, ... }:
{
  # 
  # --------------------
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environement.persistence."/persist" = {
    hideMounts = true;
  
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager"
      "/var/lib/bluetooth"
    ];

    files = [
      "/etc/machine-id"
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/seen-bssids"
      "/var/lib/NetworkManager/timestamps"
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"

    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];

  environment.etc = {
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections/";

    nixos.source = "/persist/etc/nixos";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
  };


  # Rollback results in sudo lectures after each reboot
  # ---------------------------------------------------
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';


  boot.initrd.systemd = {
    enable = true;
    
    # Reset root on each reboot
    # -------------------------
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [
        "initrd.target"
      ];
      before = [
        "sysroot.mount"
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
        mount -o subvol=/ /dev/nvme0n1p2 /mnt
        btrfs subvolume list -o /mnt/root | cut -f9 -d' ' |
        while read subvolume; do
          echo "Deleting /$subvolume subvolume"
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "Deleting /root subvolume" &&
        btrfs subvolume delete /mnt/root
        echo "Restoring blank /root subvolume"
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
        umount /mnt
      '';
    };


    # Stuff that needs to persist
    # ---------------------------
    services.persisted-files = {
      description = "Hard-link persisted files from /persist";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "sysroot.mount"
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /sysroot/etc/
        ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
        '';
    };
  };
}

