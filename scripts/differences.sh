#!/usr/bin/env bash

_tmp_root=$(mktemp -d)
mkdir -p "${_tmp_root}"
mount -o subvol=/ /dev/nvme0n1p2 "${_tmp_root}" > /dev/null 2>&1

set -euo pipefail

OLD_TRANSID=$(sudo btrfs subvolume find-new ${_tmp_root}/root-blank 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }

sudo btrfs subvolume find-new "${_tmp_root}/root" "$OLD_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq | 
while read path; do
    path="/$path"
    if [ -L "$path" ]; then
        : # The path is a symbolic link, so is probably handled by NixOS already
    elif [ -d "$path" ]; then
        : # The path is a directory, ignore
    else
        echo "$path"
    fi
done
umount "${_tmp_root}"
rm -rf "${_tmp_root}"
