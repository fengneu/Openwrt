#!/bin/sh
##libsamba contains functions to samba
create_samba_user() {
 local user
 local password
 user=$1
 password=$2
 echo $user > /dev/null
 echo $password > /dev/null

 local isExist=`cat /etc/passwd | cut -d : -f 1 | grep $user`
 if [ $isExist  ] 
 then
  echo "$user exist"
#  password=`grep $user /etc/shadow | cut -d : -f 2`
  (echo "$password"; echo "$password") | /usr/sbin/smbpasswd -s  -a $user
  echo $?
  if [ $? ]
  then
   echo "passwd input correct"
   echo "smbpasswd create user success" 
  else
   echo "passwd input wrong" 
  fi
 else
  echo "Error: the user do not exist"
 fi
}

remove_samba_user() {
 local user
 user=$1
 local isExist=`cat /etc/samba/smbpasswd | cut -d : -f 1 | grep $user`
 if [ $isExist ]; then
  echo "$user exist"
  /usr/sbin/smbpasswd -x $user
  echo "remove samba user success" # > /dev/null
 else
  echo "$user do not exist"
 fi
}

add_samba_directory() {
local user=$1
local dir="$2/$user"
mkdir -p $dir
echo "add samba directory"
#uci add samba sambashare
#cli console echo cfg06e23c

uci batch <<EOF
set samba.$user='sambashare'
set samba.$user.name='$user'
set samba.$user.read_only='no'
set samba.$user.guest_ok='yes'
set samba.$user.create_mask='777'
set samba.$user.dir_mask='777'
set samba.$user.path='$dir'
EOF
commit_samba_directory

}

remove_samba_directory() {
local user=$1
echo "remove_samba_directory"
uci delete samba.$user
commit_samba_directory
}

modify_samba_directory() {
local user=$1
local option=$2
local value=$3
echo "modify samba directory"
uci set samba.$user.$option=$value
commit_samba_directory 
}

commit_samba_directory() {
echo "commit samba directory"
uci commit samba
}


user="leon"
passwd="1234567890"
#create_samba_user $user $passwd
#cat /etc/samba/smbpasswd
#remove_samba_user feng
#cat /etc/samba/smbpasswd
#create_samba_user winter $passwd
#cat /etc/samba/smbpasswd
#remove_samba_user winter
#cat /etc/samba/smbpasswd

dir="/data"
add_samba_directory $user $dir
ls $dir
cat /etc/config/samba
modify_samba_directory $user name fengbk
cat /etc/config/samba
remove_samba_directory $user
cat /etc/config/samba
#ls $dir


