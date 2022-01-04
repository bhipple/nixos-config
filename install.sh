#!/usr/bin/env bash
set -euxo pipefail

DISK=$(ls -l /dev/disk/by-id/nvme-SAMSUNG* | grep -v part | awk '{print $9/d}')
# Happens to be the 5th partition where I want to put NixOS, and the 1st partition with the fat boot disk
ZFS=$DISK-part5
BOOT=$DISK-part1

# Make the encrypted zfs root pool and add a pw
zpool create -O mountpoint=none -O encryption=aes-256-gcm -O keyformat=passphrase rpool $ZFS

# And then the individual pools, with auto-snapshotting on /home
zfs create -o mountpoint=none rpool/root
zfs create -o mountpoint=legacy rpool/root/nixos
zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true rpool/home
zfs set compression=lz4 rpool/home

# Then mount it and off we go
mount -t zfs rpool/root/nixos /mnt

# Create new directory to mount home dataset
mkdir /mnt/home
mount -t zfs rpool/home /mnt/home

# Create filesystem for boot partition
#mkfs.vfat $BOOT

# Create directory and mount boot partition
mkdir /mnt/boot
mount $BOOT /mnt/boot

# Generate the starting config, including hardware.nix
nixos-generate-config --root /mnt
