#!/bin/sh
##libsysuser contains function to sysadmin user

add_system_group() {
 local name="$1"
 local gid="$2"
 local rc
 echo "add system or normal group $name"
 [ -f "/etc/group" ] || return 1
 lock /var/lock/group
# echo "${name}:x:${gid}:" >> /etc/group
 groupadd -f -g $gid $name
 rc=$?
 lock -u /var/lock/group
 return $rc

}

exists_system_group() {
 local name=$1
 echo "exists system or normal group $name"
 grep -qs "^$group:" /etc/group
}

modify_system_group() {
 local name=$1
 echo "modify system or normal group $name"
}

remove_system_group() {
 local name="$1"
 echo "remove system or normal group"
 groupdel $name
 echo $?
}


add_system_user() {
 local name="${1}"
 local password=$2
 local uid="${3}"
 local gid="${4:-$3}"
 local home="/data/${1}"
 local desc="${5:-$1}"
 local shell="${6:-/bin/false}"
 local rc
 echo "add system or normal user"
 [ -f /etc/passwd ] || return 1
 #lock /var/lock/passwd
 useradd $name -u $uid -g $gid -c $desc -d $home
 echo "useradd $?"
 (echo $password; sleep 2;echo $password) | /usr/bin/passwd $name 
 echo "passwd $?"
 rc=$?
 #lock -u /var/lock/passwd
 return $rc 
}

exists_system_user() {
 local name="$1"
 echo "exists system or normal user $name"
 grep -qs "^$name:" /etc/passwd
 echo $?
}

modify_system_user() {
 local name="$1"
 local password="$2"
 (echo $password; sleep 2; echo $password) | /usr/bin/passwd $name
 echo "modify system or normal $user password"

}

remove_system_user() {
 local name="$1"
 exists_system_user
 userdel $name
 echo "remove system or normal user"
}

group="cake"
gid="1200"
exists_system_group $group
cat /etc/group
add_system_group $group $gid
cat /etc/group
#remove_system_group $group
#cat /etc/group

user="cake"
passwd="1234567890"
uid="1200"
exists_system_user $user
echo $?
modify_system_user $user $passwd
echo $?
#add_system_user $user $passwd $uid 
#echo $?
#cat /etc/passwd
#modify_system_user $user
#remove_system_user $user
cat /etc/passwd
