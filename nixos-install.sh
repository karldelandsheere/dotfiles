#!/usr/bin/env bash

###############################################################################
#
# install.sh is a kind of terraforming script for NixOS.
#   It wipes everything on the specified DISK, then recreate the structure
#   based on a btrfs volume with a series of subvolumes.
#   You can chose to encrypt everything with LUKS or not.
#
#   Then it generates the hardware-config.nix.
#   It clones my dotfiles from the github repo, edits some values based on
#   your preferences, and rebuilds.
# 
# Author: Karl Delandsheere
#
# Based on
# - https://www.notashelf.dev/posts/impermanence
# - https://notes.tiredofit.ca/books/linux/page/installing-nixos-encrypted-btrfs-impermanance
# - https://willbush.dev/blog/impermanent-nixos/
# and like the whole inter-web-whateverse I guess...
#
###############################################################################

# If any error occurs, exit
# -------------------------
set -euo pipefail


# Change that to your taste
# -------------------------
DISK=/dev/nvme0n1
PART_PREFIX=p

BOOT_SIZE=2GiB
SWAP_SIZE=96GiB

ENCRYPTED=1
PASSWORD=temp0123

HOST=q3dm10
USER=unnamedplayer

DOTFILES=/etc/nixos


# Unmount everything before starting
# ----------------------------------
findmnt -R --target /mnt -o TARGET -ln | sort -r | xargs -r -n1 umount


# Erase everything on $DISK (you asked for it)
# -------------------------
wipefs "${DISK}" -a -f
sgdisk --zap-all "${DISK}"
sgdisk --clear \
        --new=1:0:+"$BOOT_SIZE" --typecode=1:ef00 --change-name=1:efi \
        --new=2:0:0 --typecode=2:8200 --change-name=2:root \
        "${DISK}"


# Format boot partition
# ---------------------
BOOT_PART="$DISK$PART_PREFIX"1
mkfs.vfat -F 32 -n boot "$BOOT_PART"


# Create encrypted or non encrypted disk and format it
# ----------------------------------------------------
if [[ "$ENCRYPTED" -eq 1 ]]; then
  echo "${PASSWORD}" | cryptsetup --verify-passphrase -v luksFormat --type luks1 "$DISK$PART_PREFIX"2
  echo "${PASSWORD}" | cryptsetup luksOpen "$DISK$PART_PREFIX"2 cryptroot
  PRIMARY_PART=/dev/mapper/cryptroot
else
  PRIMARY_PART="$DISK$PART_PREFIX"2
fi

mkfs.btrfs -f "$PRIMARY_PART"


# Store UUIDs
# -----------
PRIMARY_UUID=$(blkid | grep "$PRIMARY_PART" | awk '{print $2}' | cut -d '"' -f 2)
BOOT_UUID=$(blkid | grep "$BOOT_PART" | awk '{print $4}' | cut -d '"' -f 2)


# Create BTRFS Subvolumes
# -----------------------
mount -t btrfs /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt
btrfs subvolume create /mnt/root

mkdir -p /mnt/home
btrfs subvolume create /mnt/home/active
btrfs subvolume create /mnt/home/snapshots

btrfs subvolume create /mnt/nix

mkdir -p /mnt/persist
btrfs subvolume create /mnt/persist/active
btrfs subvolume create /mnt/persist/snapshots

mkdir -p /mnt/var_local
btrfs subvolume create /mnt/var_local/active
btrfs subvolume create /mnt/var_local/snapshots

btrfs subvolume create /mnt/var_log

btrfs subvolume create /mnt/swap


# Create readonly snapshot of the root in case of abrupt shutdown
# ---------------------------------------------------------------
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank


# Mount subvolumes
# ----------------
umount /mnt

mount -o subvol=root,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt

mkdir -p /mnt/home
mount -o subvol=home/active,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/home
mkdir -p /mnt/home/.snapshots
mount -o subvol=home/snapshots,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/home/.snapshots

mkdir -p /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/nix

mkdir -p /mnt/persist
mount -o subvol=persist/active,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/persist
mkdir -p /mnt/persist/.snapshots
mount -o subvol=persist/snapshots,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/persist/.snapshots

mkdir -p /mnt/var/local
mount -o subvol=var_local/active,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/var/local
mkdir -p /mnt/var/local/.snapshots
mount -o subvol=var_local/snapshots,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/var/local/.snapshots

mkdir -p /mnt/var/log
mount -o subvol=var_log,compress=zstd,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/var/log

mkdir -p /mnt/swap
mount -o subvol=swap,compress=none,noatime /dev/disk/by-uuid/"$PRIMARY_UUID" /mnt/swap


# Mount boot partition
# --------------------
mkdir -p /mnt/boot
mount -t vfat \
  -o defaults,nosuid,nodev,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro \
  /dev/disk/by-uuid/"$BOOT_UUID" /mnt/boot/


# Generate hardware-configuration.nix
# -----------------------------------
nixos-generate-config --root /mnt
mv /mnt/etc/nixos /mnt/etc/nixos-generated # rename to avoid any future confusion


HOST_MODULE_DIR=/"$DOTFILES"/modules/nixosModules/hosts/"$HOST";


# Import our dotfiles and customize them
# ----------------------------------------
git clone https://github.com/karldelandsheere/dotfiles.git /mnt/"$DOTFILES"
cp /mnt{/etc/nixos-generated,"$HOST_MODULE_DIR"}/hardware-configuration.nix


# Edit the dotfiles to match the host's config
# --------------------------------------------
# Convert hardware-configuration.nix to dendritic pattern
HOST_MODULE="host$(echo ${HOME} | awk '{printf "%s%s", toupper(substr($0,1,1)), substr($0,2)}')"
sed -i "s|^{ config, lib, pkgs, modulesPath, \.\.\. }:$|flake.nixosModules.${HOST_MODULE} = &|" /mnt/"$HOST_MODULE_DIR"/hardware-configuration.nix

# Create the swapfile and look for the offset
# sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
# then save it to ${HOST_MODULE_DIR}/configuration.nix

# Let's go
# --------
nixos-install --root /mnt --flake /mnt/"$DOTFILES"#"$HOST"


# nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $SCRIPT_DIR#user;

# Instructions for the first boot after install (@TODO create a burner post-install script to automate this)
# ---------------------------------------------
# echo "NixOS has been successfully installed. You can reboot and remove your live boot."
# echo "But it is not finished. You still need to follow these steps:"
# echo "1. $ sudo chown -R $USER: /etc/nixos"
# echo "2. $ nix build /etc/nixos#homeConfigurations.$USER.activationPackage"
# echo "3. $ ./result/activate"
# echo '4. $ exec $SHELL -l'



# Make the files accessible for the post-install sh
# -------------------------------------------------
# chmod -R 777 /mnt/etc/nixos


# Write a burner post-install script that will be executed on user's first login then delete itself
# -------------------------------------------------------------------------------------------------
# cat >/etc/nixos/post-install.sh <<EOL

# nix build .#homeConfigurations."$USER".activationPackage
# ./result/activate
# exec $SHELL -l
# chmod -R 755 /mnt/etc/nixos
# rm /etc/nixos/post-install.sh

# EOL





