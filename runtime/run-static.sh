#!/bin/bash
set -o xtrace

RUNTIME_DIR=/home/admin/runtime

_init_env()
{

    # cp -f /home/admin/runtime/static-web.conf /etc/supervisor/conf.d/
    chmod -R 755 ${RUNTIME_DIR}
    chown -R admin:admin ${RUNTIME_DIR}

    mkdir -p /var/run/bae/
    mkdir -p /var/log/bae/
    chmod 777 /var/run/bae/
    chmod 777 /var/log/bae/
    
    if [ -f /home/bae/.bae_profile ]; then
        . /home/bae/.bae_profile
    fi

    if [ ! -d /home/bae/app/ ]; then 
        mkdir -p /home/bae/app/
        chown bae:bae -R /home/bae/app
    fi

    if [ ! -d /home/admin/cert ]; then
            rm -rf /home/admin/runtime/lighttpd/conf/conf.d/50-https.conf
    fi
    if [ ! -f /home/admin/cert/ca.pem ]; then
        rm -rf /home/admin/runtime/lighttpd/conf/conf.d/60-https-ca.conf
    fi

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
        if [ ! -f /home/bae/app/bae_app_conf.lua ]; then
            # 如果不存在lua则生成空的lua
            echo 'return 0' > /home/bae/app/bae_app_conf.lua
        fi
    fi

    touch /home/bae/log/slowlog.log
}

_start()
{
    _init_env
    cd /home/admin/runtime
    /home/admin/runtime/lighttpd/bin/lighttpd -f /home/admin/runtime/lighttpd/conf/lighttpd.conf -m /home/admin/runtime/lighttpd/lib  -D
    return 0
}

_stop() {
    /etc/init.d/supervisor stop
    if [ $? -ne 0 ]; then
        sleep 1
        /etc/init.d/supervisor stop
    fi
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
