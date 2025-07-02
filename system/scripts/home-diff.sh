#!/usr/bin/env bash
# @todo Make it more dynamic and less system dependant
#       by replacing /nvme0n1p2 with a global const or something
# --------------------------------------------------------------

_tmp_root=$(mktemp -d)
mkdir -p "${_tmp_root}"
mount -o subvol=/ /dev/nvme0n1p2 "${_tmp_root}" > /dev/null 2>&1

set -euo pipefail

OLD_TRANSID=$(sudo btrfs subvolume find-new "${_tmp_root}/home-blank" 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }

# sudo btrfs subvolume find-new "${_tmp_root}/home/active" "$OLD_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq | 
sudo btrfs subvolume find-new "${_tmp_root}/home/active" "$OLD_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq | 
while read -r path; do
    path="/$path"
    fpath="$_tmp_root/home/active$path"
    rpath="$(realpath "$fpath")"

    if [[ $rpath == "$fpath"  ]] && [[ $path != *"/.cache/"* ]] && [[ "$path" != *"Cache"* ]] && [[ "$path" != *"Signal/attachments.noindex"*  ]] && [[ "$path" != *"Signal/badges.noindex"* ]] && [[ "$path" != *"Signal/stickers.noindex"* ]]; then
      echo "$rpath"
    fi
done
umount "${_tmp_root}"
rm -rf "${_tmp_root}"
