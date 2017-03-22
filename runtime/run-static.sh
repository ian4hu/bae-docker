#!/bin/bash

RUNTIME_DIR=/home/admin/runtime

_init_env()
{

  cp -f /home/admin/runtime/static-web.conf /etc/supervisor/conf.d/

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

    USE_USERLIGHTTPD_CONF_CMD='include "/home/bae/app/bae_lighttpd_user.conf"'
    NOUSE_USERLIGHTTPD_CONF_CMD='#include_user_lighttpd.conf'
    #check if user lighttpd conf exist
    if [ -f /home/bae/app/bae_lighttpd_user.conf ]; then
        sed -i 's/^/#/g' /home/admin/runtime/lighttpd/conf/conf.d/15-mod_vhost_magnet.conf  #取消lua的配置
        sed -i "s&$NOUSE_USERLIGHTTPD_CONF_CMD&$USE_USERLIGHTTPD_CONF_CMD&g"    /home/admin/runtime/lighttpd/conf/lighttpd.conf #使用用户自定义的lighttpd配置
        sed -i '/var.use_bae_user_lighttpd_conf/d' /home/bae/app/bae_lighttpd_user.conf
        echo "var.use_bae_user_lighttpd_conf = 1" >> /home/bae/app/bae_lighttpd_user.conf
        killall -9 lighttpd 2>/dev/null
    else
        sed -i 's/#//g' /home/admin/runtime/lighttpd/conf/conf.d/15-mod_vhost_magnet.conf   #恢复lua的配置
        sed -i "s&$USE_USERLIGHTTPD_CONF_CMD&$NOUSE_USERLIGHTTPD_CONF_CMD&g"    /home/admin/runtime/lighttpd/conf/lighttpd.conf #使用用户自定义的lighttpd配置
    fi

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
    return 0
}

pre_app_update()
{
#   _stop

    return 0
}

post_app_update()
{
    _init_env


    return 0
#   _start
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
