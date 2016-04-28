#!/bin/sh
##libdiskutil contains functions to disk

find_sdisk_info() {
 local sdisk=$1
 echo "find $sdisk info ..."
 local is_exist=0	#0 false, 1 true
 if fdisk -l /dev/$sdisk
 then
  echo "is exist"; is_exist=0; echo "find $sdisk info ***"; return 0
 else
  echo "not exist"; is_exist=1; echo "find $sdisk info ???"; return 1
 fi
}

make_sdisk_part() {
 local sdisk=$1
 echo "make $sdisk part ..."
 parted /dev/$sdisk "mkpart primary 0% 100%" -s
 fdisk -l /dev/$sdisk
}

remove_sdisk_part() {
 local sdisk=$1
 echo "remove $sdisk part ..."
 parted /dev/$sdisk rm 1 -s
 fdisk -l /dev/$sdisk
}

create_physical_volumn() {
 local sdisk=$1
 echo "create physical volumn ..."
 if lvm pvcreate /dev/$sdisk[1] -ff -y
 then
  lvm pvdisplay /dev/$sdisk[1]
  echo "create physical volumn ***"; return 0
 else
  echo "create physical volumn ???"; return 1
 fi
}

remove_physical_volumn() {
 local sdisk=$1
 echo "remove physical volumn ..."
 if lvm pvremove /dev/$sdisk[1]
 then
  lvm pvdisplay /dev/$sdisk[1]
  echo "remove physical volumn ***"; return 0
 else
  echo "remove physical volumn ???"; return 1
 fi
}

create_lvm_group() {
 local vdisk=$1
 shift
 local sdisk=$@
 echo "create lvm group $vdisk ..."
 if lvm vgcreate /dev/$vdisk ${sdisk}
 then
  lvm vgdisplay /dev/$vdisk
  echo "create lvm group ***"; return 0
 else
  echo "create lvm group ???"; return 1
 fi
}

remove_lvm_group() {
 local vdisk=$1
 echo "remove lvm group $vdisk ..."
 if lvm vgremove /dev/$vdisk -f
 then 
  lvm vgdisplay /dev/$vdisk
  echo "remove lvm group ***"; return 0
 else
  echo "remove lvm group ???"; return 1
 fi
}

create_lvm_disk() {
 local vdisk=$1
 local disk=$2
 echo "create lvm disk $disk ..."
 local vg_free_string=`lvm vgs -o vg_free_count`
 local vg_free_count=`echo $vg_free_string |  cut -d ' ' -f 2`
 if lvm lvcreate -l $vg_free_count -n $disk $vdisk -K
 then
  lvm lvdisplay /dev/$vdisk/$disk
  echo "create lvm disk ***"; return 0
 else
  echo "create lvm disk ???"; return 1
 fi
}

remove_lvm_disk() {
 local vdisk=$1
 local disk=$2
 echo "remove lvm $disk ..."
 if lvm lvremove /dev/$vdisk/$disk -f
 then
  lvm lvdisplay /dev/$vdisk/$disk
  echo "remove lvm disk ***"; return 0
 else
  echo "remove lvm disk ???"; return 1
 fi
}

format_lvm_disk() {
 local vdisk=$1
 local disk=$2
 echo "format lvm disk ext4 ..."
 if mkfs.ext4 /dev/$vdisk/$disk
 then
  echo "format lvm $disk ext4 ***"; return 0
 else
  echo "format lvm $disk ext4 ???"; return 1
 fi
}

mount_lvm_disk() {
 local vdisk="$1"
 local disk="$2"
 local dir="$3"
 echo "mount lvm disk ..."
 if ( mount -t ext4 /dev/$vdisk/$disk $dir )
 then
  df -h
  echo "mount lvm disk ***"; return 0
 else
  echo "mount lvm disk ???"; return 1
 fi
}

umount_lvm_disk() {
 local dir=$1
 echo "umount lvm $dir..."
 if umount $dir
 then
  df -h
#  df -h | grep $dir
  echo "umount lvm $dir ***"; return 0
 else
  echo "umount lvm $dir ???"; return 1
 fi
}
 
create_raid_array() {
 local mdisk=$1
 shift
 local sdisk=$@
 echo "create raid array ..."
 if ( echo "y" | mdadm -C /dev/$mdisk -f  -l1 -n2 ${sdisk})
 then
  df -h
  echo "create raid array $mdisk ***"; return 0;
 else
  echo "create raid array $mdisk ???"; return 1;
 fi
}

stop_raid_array() {
 local mdisk=$1
 echo "stop raid array ..."
 if ( mdadm -S /dev/$mdisk ) 
 then
  df -h
  echo "stop raid array $mdisk ***"; return 0;
 else
  echo "stop raid array $mdisk ???"; retrun 1
 fi
}

display_raid_array() {
 local mdisk=$1
 echo "display raid array ..."
 if ( mdadm -D /dev/$mdisk )
 then
  echo "display raid array $mdisk ***"; return 0;
 else
  echo "display raid array $mdisk ???"; retrun 1
 fi
}

format_raid_array() {
 local mdisk=$1
 echo "format lvm disk ext4 ..."
 if mkfs.ext4 /dev/$mdisk
 then
  echo "format raid $mdisk ext4 ***"; return 0
 else
  echo "format raid $mdisk ext4 ???"; return 1
 fi
}

mount_raid_array() {
 local mdisk="$1"
 local dir="$2"
 echo "mount raid disk ..."
 if ( mount -t ext4 /dev/$mdisk $dir )
 then
  df -h
  echo "mount raid disk ***"; return 0
 else
  echo "mount raid disk ???"; return 1
 fi
}

umount_raid_array() {
 local dir=$1
 echo "umount raid $dir..."
 if umount $dir
 then
  df -h
#  df -h | grep $dir
  echo "umount raid $dir ***"; return 0
 else
  echo "umount raid $dir ???"; return 1
 fi
}




