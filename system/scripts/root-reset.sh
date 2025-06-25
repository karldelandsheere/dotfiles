#!/usr/bin/env bash

mkdir -p /mnt
mount -o subvol=/ /dev/nvme0n1p2 /mnt

btrfs subvolume list -o /mnt/root | cut -f9 -d' ' | while read subvolume; do
  echo "Deleting /$subvolume subvolume"
  btrfs subvolume delete "/mnt/$subvolume"
done && echo "Deleting /root subvolume" &&
btrfs subvolume delete /mnt/root

echo "Restoring blank /root subvolume"
btrfs subvolume snapshot /mnt/root-blank /mnt/root

umount /mnt
echo "All done, /root is now back to pristine state"
