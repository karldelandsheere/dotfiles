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

mount -o subvol=/ ${BTRFS_VOL} ${MNT_DIR}

HOME_PRISTINE="${MNT_DIR}/home-blank"
HOME_SUBVOL="${MNT_DIR}/home/active"
HOME_NEXT_SNAPSHOT="${MNT_DIR}/home/snapshots/$(date '+%Y%m%d-%Hh%M')"

echo "Creating a snapshot of /home/active state" &&
btrfs subvolume snapshot ${HOME_SUBVOL} ${HOME_NEXT_SNAPSHOT}

echo "Deleting /home/active subvolume" &&
btrfs subvolume delete ${HOME_SUBVOL}

echo "Restoring blank /home/active subvolume"
btrfs subvolume snapshot ${HOME_PRISTINE} ${HOME_SUBVOL}

umount ${MNT_DIR}
echo "All done, /home is now back to pristine state"
