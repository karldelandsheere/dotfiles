#!/usr/bin/env bash

###############################################################################
#
# differences.sh does a few things:
#   It reads everything under the root and home subvolumes and
#   compares what it finds on the pristine versions of those subvolumes.
#   Everything that is not on the pristine versions (except what is ignored)
#   is considered a difference.
#   It echoes those differences so you can then decide what you want to add
#   to the /persist subvolume.
#
###############################################################################

# If any error occurs, exit
# -------------------------
set -euo pipefail

ROOT_PART=/dev/mapper/cryptroot

# Creating a tmp root mount
# -------------------------
TMP_ROOT=$(mktemp -d)
mkdir -p "${TMP_ROOT}"
mount -o subvol=/ "${ROOT_PART}" "${TMP_ROOT}" > /dev/null 2>&1

# Process given arguments
# -----------------------
SUBVOL="${1:-root}"          # subvolume to check (e.g. root, home/active, ...)
BLANK="${2:-$SUBVOL}-blank"  # subvolume to compare it to
IGNORE="${3:-}"              # ignore paths matching this|these pattern|s

# Retrieve transient id
BLANK_TRANSID=$(sudo btrfs subvolume find-new "${TMP_ROOT}/${BLANK}" 9999999)
BLANK_TRANSID=${BLANK_TRANSID#transid marker was }

# Let's go then
# -------------
echo "Checking for differences/new files on subvolume '${SUBVOL}'"
echo "--------"

sudo btrfs subvolume find-new "${TMP_ROOT}/${SUBVOL}" "$BLANK_TRANSID" \
  | sed '$d' | cut -f17- -d' ' | sort -u | while read -r path; do
  path="/$path"
  fpath="${TMP_ROOT}/${SUBVOL}${path}"
  rpath="$(realpath "$fpath")"

  # Skip if symlink-resolved
  [[ $rpath != "$fpath" ]] && continue

  # Skip if ignore pattern is provided and $path matches it
  [[ -n $IGNORE && $path =~ $IGNORE ]] && continue

  # echo this one
  echo "$path"
done

echo "--------"
echo "That's it."

# We're done, so unmount temp root mount
# --------------------------------------
echo "Unmounting temp root mount."
umount "${TMP_ROOT}"
rm -rf "${TMP_ROOT}"
echo "We're done here. Bye."
