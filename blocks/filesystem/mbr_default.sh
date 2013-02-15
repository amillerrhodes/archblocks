_drivequery;

BOOT_DRIVE=$INSTALL_DRIVE # expected format /dev/sda
SDX=`echo $INSTALL_DRIVE | cut -d '/' -f3` # turns /dev/sda into sda
PARTITION_EFI_BOOT=0

LABEL_BOOT=boot
LABEL_ROOT=root
LABEL_HOME=home
LABEL_SWAP=swap

PARTITION_BOOT=1
PARTITION_ROOT=2
PARTITION_SWAP=3
PARTITION_HOME=4

MOUNT_PATH=/mnt/


_filesystem_pre_baseinstall () {
_countdown 10 "ERASING $INSTALL_DRIVE"

boot=$((   1   +   100    ))
root=$(( $boot + (1024*5) ))
swap=$(( $root + (1024*1) ))

max=$(( $(cat /sys/block/$SDX/size) * 512 / 1024 / 1024 - 1 ))

#for part in `lsblk --output MAJ:MIN /dev/sda | grep ":[1-9]" | cut -d ':' -f 2`
#do
#    parted $INSTALL_DRIVE --script -- rm $part
#done

# Create partition table
parted $INSTALL_DRIVE --script -- mklabel msdos
parted $INSTALL_DRIVE --script -- unit MiB mkpart primary 1 $boot
parted $INSTALL_DRIVE --script -- unit MiB mkpart primary $boot $root
parted $INSTALL_DRIVE --script -- unit MiB mkpart primary linux-swap $root $swap
parted $INSTALL_DRIVE --script -- unit MiB mkpart primary $swap $max

# make filesystems
mkfs.ext2 ${INSTALL_DRIVE}${PARTITION_BOOT}
mkfs.ext4 ${INSTALL_DRIVE}${PARTITION_ROOT}
mkfs.ext4 ${INSTALL_DRIVE}${PARTITION_HOME}
mkswap ${INSTALL_DRIVE}${PARTITION_SWAP}

swapon ${INSTALL_DRIVE}${PARTITION_SWAP}

# mount target
mkdir -p ${MOUNT_PATH}
mount ${INSTALL_DRIVE}${PARTITION_ROOT} ${MOUNT_PATH}
mount ${INSTALL_DRIVE}${PARTITION_BOOT} ${MOUNT_PATH}${LABEL_BOOT}
mount ${INSTALL_DRIVE}${PARTITION_HOME} ${MOUNT_PATH}${LABEL_HOME}
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
