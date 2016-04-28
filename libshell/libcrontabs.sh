#!/bin/sh
#libcrontabs contains function to cron
readcontab() {
 local curuser  #param $1 for current user

 local fname    #local value for contab file name
 local fcontent #internal value for contab file content

 curuser=$1
 fname=/etc/crontabs/$curuser
 if [ -f $fname ]
 then
  echo "$fname is exists" #curuser fname exists
 else
  touch $fname
 fi

 fcontent=`cat $fname`
 echo $fcontent
}

writecontab() {
 local curuser
 local fcontent

 local fname
 
 curuser=$1
 echo "$curuser" > /dev/null
 shift 
 fcontent="$*"
 fname=/etc/crontabs/$curuser

 if [ -f $fname ]
 then
  echo "$fname exists" > /dev/null
 else
  touch $fanme
 fi
 echo "$fcontent" > $fname
 cat $fname > /dev/null
 echo $? > /dev/null
}

applycontab() {
 /usr/sbin/crond -f -c /etc/crontabs -l 8
}


## Test usecase to use libcron functions
#source /lib/config/libcrontabs.sh
#readcontab root
#readcontab leon
#CRONSTRING="*/30 * * * * date >> /data/cron/cronlog"
#writecontab root "$CRONSTRING"
#writecontab leon "$CRONSTRING"
#applycontab

