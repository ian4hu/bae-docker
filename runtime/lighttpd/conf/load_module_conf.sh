#!/bin/bash

#help accesslog to print server ip
HOST_IP=`ifconfig eth0 | grep inet | sed '2d'| gawk '{ print $2}'| gawk -F: '{ print $2 }'`
echo "var.host_ip = \"$HOST_IP\""

#help accesslog to print appid
APPID=`echo $BAE_ENV_APPID`
echo "var.appid = \"$APPID\""

CONFDIR=$1/conf/conf.d/
filelist=`ls $CONFDIR`
for file in $filelist
do 
	echo "include \"$CONFDIR/$file\""
done
