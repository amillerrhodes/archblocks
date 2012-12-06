_drivequery;

BOOT_DRIVE=$INSTALL_DRIVE # expected format /dev/sda
PARTITION_EFI_BOOT=0
LABEL_SWAP=swap
LABEL_ROOT=root
MOUNT_PATH=/mnt


_filesystem_pre_baseinstall () {
_countdown 10 "ERASING $INSTALL_DRIVE"

dd if=/dev/zero of=/dev/sda bs=512 count=1
echo "n
p
1


w" | fdisk $INSTALL_DRIVE

PARTITION_ROOT=1
# make filesystems
#mkswap ${INSTALL_DRIVE}${PARTITION_SWAP}
#swapon ${INSTALL_DRIVE}${PARTITION_SWAP}
mkfs.btrfs ${INSTALL_DRIVE}${PARTITION_ROOT}
# mkswap /dev/sda2

# mount target
mkdir -p ${MOUNT_PATH}
mount ${INSTALL_DRIVE}${PARTITION_ROOT} ${MOUNT_PATH}
}

_filesystem_post_baseinstall () {
# not using genfstab here since it doesn't record partlabel labels
genfstab -U -p /mnt >> /mnt/etc/fstab
}

_filesystem_pre_chroot ()
{
}

_filesystem_post_chroot ()
{
}
