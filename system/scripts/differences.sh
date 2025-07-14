#!/usr/bin/env bash
# @todo Make it more dynamic and less system dependant
#       by replacing /nvme0n1p2 with a global const or something
# --------------------------------------------------------------

# Creating a tmp root mount
# -------------------------
_tmp_root=$(mktemp -d)
mkdir -p "${_tmp_root}"
# mount -o subvol=/ /dev/nvme0n1p2 "${_tmp_root}" > /dev/null 2>&1
mount -o subvol=/ /dev/mapper/cryptroot "${_tmp_root}" > /dev/null 2>&1

# If any error occurs, exit
# -------------------------
set -euo pipefail


# Get pristine root transid
# -------------------------
OLD_ROOT_TRANSID=$(sudo btrfs subvolume find-new "${_tmp_root}/root-blank" 9999999)
OLD_ROOT_TRANSID=${OLD_ROOT_TRANSID#transid marker was }

# Search for differences on root
# ------------------------------
sudo btrfs subvolume find-new "${_tmp_root}/root" "$OLD_ROOT_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq | 
while read -r path; do
  path="/$path"
  fpath="$_tmp_root/root$path"
  rpath="$(realpath "$fpath")"

  if [[ $rpath == "$fpath"  ]] && \
     [[ $path != *"/.cache/"* ]]; then
    echo "$path"
  fi
done


# Get pristine home transid
# -------------------------
OLD_HOME_TRANSID=$(sudo btrfs subvolume find-new "${_tmp_root}/home-blank" 9999999)
OLD_HOME_TRANSID=${OLD_HOME_TRANSID#transid marker was }

# Search for differences on home
# ------------------------------
sudo btrfs subvolume find-new "${_tmp_root}/home/active" "$OLD_HOME_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq | 
while read -r path; do
  path="/$path"
  fpath="$_tmp_root/home/active$path"
  rpath="$(realpath "$fpath")"

  if [[ $rpath == "$fpath"  ]] && \
     [[ $path != *"/.cache/"* ]] && \
     [[ "$path" != *"Cache"* ]] && \
     [[ "$path" != *"Signal/attachments.noindex"*  ]] && \
     [[ "$path" != *"Signal/badges.noindex"* ]] && \
     [[ "$path" != *"Signal/stickers.noindex"* ]]; then
    echo "$path"
  fi
done


# We're done, so unmount temp root mount
# --------------------------------------
umount "${_tmp_root}"
rm -rf "${_tmp_root}"
