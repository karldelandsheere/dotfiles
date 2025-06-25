#!/usr/bin/env bash

if [ "$UID" -ne "0" ];
then
	>&2 echo "One can not simply mount and manipulate the btrfs root subvolume"
	exit 1
fi

MNT_DIR=/mnt
mkdir -p ${MNT_DIR}

BTRFS_VOL=/dev/nvme0n1p2

if [ ! -r "$BTRFS_VOL" ];
then
	>&2 echo "Device '$BTRFS_VOL' not found"
	exit 1
fi

# mount -t btrfs ${BTRFS_VOL} ${MNT_DIR}
mount -o subvol=/ ${BTRFS_VOL} ${MNT_DIR}

ROOT_PRISTINE="${MNT_DIR}/root-blank"
ROOT_SUBVOL="${MNT_DIR}/root"

btrfs subvolume list -o ${ROOT_SUBVOL} | cut -f9 -d' ' | while read -r subvolume;
do
  echo "Deleting /$subvolume subvolume"
  btrfs subvolume delete "${MNT_DIR}/$subvolume"
done &&
echo "Deleting /root subvolume" &&
btrfs subvolume delete ${ROOT_SUBVOL}

echo "Restoring blank /root subvolume"
btrfs subvolume snapshot ${ROOT_PRISTINE} ${ROOT_SUBVOL}

umount ${MNT_DIR}
echo "All done, /root is now back to pristine state"
