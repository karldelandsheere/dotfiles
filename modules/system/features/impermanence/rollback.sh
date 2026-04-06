#!/usr/bin/env bash

###############################################################################
#
# rollback.sh takes care of getting root and home/active subvolumes to their
# pristine states.
#
###############################################################################

# This script needs to be run by priviledge user
# ----------------------------------------------
if [ "$UID" -ne "0" ];
then
	>&2 echo "One can not simply mount and manipulate the btrfs root subvolume"
	exit 1
fi

# If any error occurs, exit
# -------------------------
set -euo pipefail

# This is replaced during install.sh, default is __PRIMARY_PART__
ROOT_PART=/dev/mapper/cryptroot

# Create root mount
# -----------------
MNT_DIR=/mnt
mkdir -p ${MNT_DIR}

# Go on, mount it then
# --------------------
mount -o subvol=/ ${ROOT_PART} ${MNT_DIR}


# Rolling back root to its pristine state
# ---------------------------------------
ROOT_PRISTINE="${MNT_DIR}/root-blank"
ROOT_SUBVOL="${MNT_DIR}/root"

# First, mount the current root subvolume
# Then list and wipe everything inside it
# And finally, delete it
# ----------------------
btrfs subvolume list -o ${ROOT_SUBVOL} | cut -f9 -d' ' | while read -r subvolume;
do
  echo "Deleting /$subvolume subvolume"
  btrfs subvolume delete "${MNT_DIR}/$subvolume"
done &&
echo "Deleting /root subvolume" &&
btrfs subvolume delete ${ROOT_SUBVOL}

# Now we restore it back from its pristine state, and its done
# ------------------------------------------------------------
echo "Restoring blank /root subvolume" &&
btrfs subvolume snapshot ${ROOT_PRISTINE} ${ROOT_SUBVOL} &&
echo "/root is now back to pristine state!"


# Rolling back home to its pristine state
# But home is different from root:
# - There are no subvolumes under it
# - And we want to keep a snapshot of it
# --------------------------------------
HOME_PRISTINE="${MNT_DIR}/home-blank"
HOME_SUBVOL="${MNT_DIR}/home/active"
HOME_NEXT_SNAPSHOT="${MNT_DIR}/home/snapshots/$(date '+%Y%m%d-%Hh%M')"

# So first, we make a snapshot of it
# ----------------------------------
echo "Creating a snapshot of /home/active state" &&
btrfs subvolume snapshot ${HOME_SUBVOL} ${HOME_NEXT_SNAPSHOT}

# Then we delete it
# -----------------
echo "Deleting /home/active subvolume" &&
btrfs subvolume delete ${HOME_SUBVOL}

# And finally, we restore it back from its pristine state, and its done
# ---------------------------------------------------------------------
echo "Restoring blank /home/active subvolume" &&
btrfs subvolume snapshot ${HOME_PRISTINE} ${HOME_SUBVOL} &&
echo "/home is now back to pristine state"

# And we're done
# --------------
umount ${MNT_DIR} &&
echo "All done. Proceed."
