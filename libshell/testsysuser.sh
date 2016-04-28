#!/bin/sh
##test usecase system user step by step

##include shell library as follows:
source /data/libshell/libsysuser.sh
source /data/libshell/libsamba.sh

##set global parameter for test
#user="apple"
#user="berry"
#user=cake
#user=dog
#user=elephant
user=aaa
password="1234567890"

##add system user
exists_system_user $user

[ -z $? ] || add_system_user $user
#cat /etc/passwd 
modify_system_user $user $password
#cat /etc/shadow

##add samba user
create_samba_user $user $password
cat /etc/samba/smbpasswd
add_samba_directory $user
cat /etc/config/samba 
cat /etc/config/samba | grep $user 
/etc/init.d/samba restart

