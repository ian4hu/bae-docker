#!/bin/bash

PHP_HOME=/home/admin/php
RUNTIME_DIR=/home/admin/runtime

_init_env()
{
	[ ! -L /home/admin/php/etc/php-fpm.conf ] && {
			ln -s /home/admin/runtime/php-fpm.conf /home/admin/php/etc/php-fpm.conf
	}
	[ ! -L /home/admin/php/etc/php.ini ] && {
			ln -s /home/admin/runtime/php.ini /home/admin/php/etc/php.ini
	}
	cp -f /home/admin/runtime/php-web.conf /etc/supervisor/conf.d/
	mkdir -p ${PHP_HOME}/etc/php/conf.d/

  chmod -R 755 ${PHP_HOME}/lib/php/20121212/
  chmod -R 755 ${PHP_HOME}/etc/php/conf.d/

  chmod -R 755 ${RUNTIME_DIR}
  chown -R admin:admin ${RUNTIME_DIR}

  mkdir -p /var/run/bae/
  mkdir -p /var/log/bae/
  chmod 777 /var/run/bae/
  chmod 777 /var/log/bae/
	
	[ -f /home/bae/.bae_profile ] && {
		. /home/bae/.bae_profile
	}

	[ ! -d /home/bae/app/ ] && {
		mkdir -p /home/bae/app/
		chown bae:bae -R /home/bae/app
	}
	[ ! -d /home/admin/cert ] && {
	        rm -rf /home/admin/runtime/lighttpd/conf/conf.d/50-https.conf
	}
	[ ! -f /home/admin/cert/ca.pem ] && {
		rm -rf /home/admin/runtime/lighttpd/conf/conf.d/60-https-ca.conf
	}  

	cp -f /home/admin/runtime/ext/*.so ${PHP_HOME}/lib/php/20121212/
	cp -f /home/admin/runtime/ext/*.ini ${PHP_HOME}/etc/php/conf.d/

	if [ -d /home/bae/app/user_extention/ ]; then
		cp -f /home/bae/app/user_extention/*.so ${PHP_HOME}/lib/php/20121212/ #upload user`s so extention
		cp -f /home/bae/app/user_extention/*.ini ${PHP_HOME}/etc/php/conf.d/	#upload user`s so extention ini
	fi

	if [ -f /home/bae/app/php.ini ]; then
		cp /home/bae/app/php.ini ${PHP_HOME}/etc/php/conf.d/bae_user.ini
	fi

	echo "<?php" > /home/admin/runtime/baeapi/BaePrePend.php
	cat /home/bae/.bae_profile |sed "s/=/','/g"|sed "s/export /define('/g"|sed "s/$/');/g">>/home/admin/runtime/baeapi/BaePrePend.php
	[ -f /home/bae/.user_profile ] && {
		. /home/bae/.user_profile
		checku=`grep '=' /home/bae/.user_profile|wc -l `
		if [ $checku -ge 1 ]
		then
		cat /home/bae/.user_profile |sed "s/=/','/g"|sed "s/\"//g"|sed "s/^/define('/g"|sed "s/export *//g"|sed "s/$/');/g"  >> /home/admin/runtime/baeapi/BaePrePend.php
		fi
	}
   	echo "?>" >> /home/admin/runtime/baeapi/BaePrePend.php

	sh /home/admin/runtime/update_fpm_conf.sh
	sed -i '/request_terminate_timeout/d' /home/admin/runtime/php-fpm.conf
	#check if php.ini exist
	if [ -f /home/bae/app/php.ini ]; then
		sed -i 's/ //g' /home/bae/app/php.ini
        # comment in php.ini must starts with ';'
		sed -i '/^;/d' /home/bae/app/php.ini
		maxtime_line=`grep max_execution_time /home/bae/app/php.ini | wc -l`
		if [ $maxtime_line -ge 1 ]
		then
			#grep max_execution_time /home/bae/app/php.ini >> /home/admin/runtime/php-fpm.conf
			maxexectime=`grep max_execution_time /home/bae/app/php.ini`
			eval $maxexectime
			sed -i '/request_slowlog_timeout/d' /home/admin/runtime/php-fpm.conf
			#sed -i "s/^server.max-connection-idle.*$/server.max-connection-idle = $max_execution_time/g" lighttpd/conf/lighttpd.conf
			echo "request_slowlog_timeout=$max_execution_time" >> /home/admin/runtime/php-fpm.conf
			grep max_execution_time /home/bae/app/php.ini >> /home/admin/runtime/php-fpm.conf
		else
			echo "max_execution_time = 30" >> /home/admin/runtime/php-fpm.conf
		fi
		sed -i 's/max_execution_time/request_terminate_timeout/g' /home/admin/runtime/php-fpm.conf
	else
		echo "request_terminate_timeout = 30" >> /home/admin/runtime/php-fpm.conf
	fi

	USE_USERLIGHTTPD_CONF_CMD='include "/home/bae/app/bae_lighttpd_user.conf"'
	NOUSE_USERLIGHTTPD_CONF_CMD='#include_user_lighttpd.conf'
	#check if user lighttpd conf exist
	if [ -f /home/bae/app/bae_lighttpd_user.conf ]; then
		sed -i 's/^/#/g' /home/admin/runtime/lighttpd/conf/conf.d/15-mod_vhost_magnet.conf	#取消lua的配置
		sed -i "s&$NOUSE_USERLIGHTTPD_CONF_CMD&$USE_USERLIGHTTPD_CONF_CMD&g"	/home/admin/runtime/lighttpd/conf/lighttpd.conf	#使用用户自定义的lighttpd配置
		sed -i '/var.use_bae_user_lighttpd_conf/d' /home/bae/app/bae_lighttpd_user.conf
		echo "var.use_bae_user_lighttpd_conf = 1" >> /home/bae/app/bae_lighttpd_user.conf
		killall -9 lighttpd 2>/dev/null
	else
		sed -i 's/#//g' /home/admin/runtime/lighttpd/conf/conf.d/15-mod_vhost_magnet.conf	#恢复lua的配置
		sed -i "s&$USE_USERLIGHTTPD_CONF_CMD&$NOUSE_USERLIGHTTPD_CONF_CMD&g"	/home/admin/runtime/lighttpd/conf/lighttpd.conf	#使用用户自定义的lighttpd配置
	fi

	chmod 755 -R /home/admin/runtime/ext
	chmod 755 -R /home/admin/runtime/baeapi
	chmod 755 -R ${PHP_HOME}/lib/php/20121212
	chmod 755 -R ${PHP_HOME}/etc/php/conf.d
	touch /home/bae/log/slowlog.log
}

_start()
{
	_init_env

	/etc/init.d/supervisor start
	for i in `seq 15`
        do
                sleep 2;
                ps auxf |grep -v grep | grep "^admin.*lighttpd .*" >/dev/null 2>&1
                if [ $? -ne 0 ]; then
                        continue;
                fi
                chmod a+rw /home/bae/log/* 2>/dev/null
                break;
        done
    [ $? -ne 0 ] && {
		return 1
    }
	return 0
}

_stop() {
	/etc/init.d/supervisor stop
	[ $? -ne 0 ] && {
        sleep 1
        /etc/init.d/supervisor stop
    }
        sleep 1
        killall -9 supervisord 2>/dev/null
        killall -9 lighttpd 2>/dev/null
	#netstat -apn|grep '127.0.0.1:9000'|awk '{print $7}'|awk -F / '{system("kill " $1)}'
        killall -9 php-fpm 2>/dev/null
	ps aux | grep php-fpm >/dev/null 2>&1
        [ $? -ne 0 ] && {
        sleep 1
        killall -9 php-fpm 2>/dev/null
        }
	fpmnum=`ps aux|grep php-fpm|wc -l`
	if [ $fpmnum -ge 2 ]
	then
	sleep 1
	killall -9 php-fpm 2>/dev/null
	fi
        return 0
}

pre_app_update()
{
#	_stop
	rm -rf ${PHP_HOME}/lib/php/20121212/*
	rm -rf ${PHP_HOME}/etc/php/conf.d/*
	supervisorctl stop php-fpm > /dev/null 2>&1
	[ $? -ne 0 ] && {
		sleep 1
		supervisorctl stop php-fpm > /dev/null 2>&1
	}
	#netstat -apn|grep '127.0.0.1:9000'|awk '{print $7}'|awk -F / '{system("kill " $1)}'
	killall -9 php-fpm >/dev/null 2>&1
	[ $? -ne 0 ] && {
		sleep 1
		killall -9 php-fpm >/dev/null 2>&1
	}
	ps aux | grep php-fpm >/dev/null 2>&1
	[ $? -ne 0 ] && {
	sleep 1
	killall -9 php-fpm 2>/dev/null
	}
	fpmnum=`ps aux|grep php-fpm|wc -l`
	if [ $fpmnum -ge 2 ]
	then
	sleep 1
	killall -9 php-fpm 2>/dev/null
	fi

	return 0

}

post_app_update()
{
	_init_env

	supervisorctl start php-fpm
	ps aux | grep php-fpm >/dev/null 2>&1
	[ $? -ne 0 ] && {
	sleep 1
	supervisorctl start php-fpm
	}
	fpmnum=`ps aux|grep php-fpm|wc -l`
	if [ $fpmnum -le 2 ]
	then
	sleep 1
	supervisorctl start php-fpm
	fi

	return 0
#	_start
}

start()
{
   _start
}

stop()
{
   _stop
}

restart()
{
   _stop
   sleep 1
   _start
}

CMD=$1
eval $CMD
