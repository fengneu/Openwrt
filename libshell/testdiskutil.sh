#!/bin/sh
##Test unittest for libdiskutil.sh
source /data/libshell/libdiskutil.sh

SDA_EXISTS=0
SDB_EXISTS=0
SDC_EXISTS=0
df -h
find_sdisk_info sda
SDA_EXISTS=$?
find_sdisk_info sdb
SDB_EXISTS=$?
find_sdisk_info sdc
SDC_EXISTS=$?
echo $SDA_EXISTS
echo $SDB_EXISTS
echo $SDC_EXISTS
make_sdisk_part sda
make_sdisk_part sdb
create_physical_volumn sda
create_physical_volumn sdb
create_lvm_group vdisk /dev/sda1 /dev/sdb1
create_lvm_disk vdisk disk
format_lvm_disk vdisk disk
mount_lvm_disk vdisk disk /data/disk
umount_lvm_disk /data/disk
remove_lvm_disk vdisk disk
remove_lvm_group vdisk
remove_physical_volumn sda
remove_physical_volumn sdb
remove_sdisk_part sda
remove_sdisk_part sdb
df -h
make_sdisk_part sda
make_sdisk_part sdb
create_raid_array md1 /dev/sda1 /dev/sdb1
display_raid_array md1
format_raid_array md1
mount_raid_array md1 /data/md1
umount_raid_array /data/md1
stop_raid_array md1
remove_sdisk_part sda
remove_sdisk_part sdb
df -h
make_sdisk_part sda
make_sdisk_part sdb
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sdb1
mount -t ext4 /dev/sda1 /data/sda
mount -t ext4 /dev/sdb1 /data/sdb
df -h
umount /data/sda
umount /data/sdb
df -h
remove_sdisk_part sda
remove_sdisk_part sdb
df -h
