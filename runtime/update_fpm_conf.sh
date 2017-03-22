#!/bin/bash

memsize=$BAE_MEMORY
cginum=50
case $memsize in
	128)
		cginum=10
	;;
	256)
		cginum=20
	;;
	512)
		cginum=30
	;;
	1024)
		cginum=50
	;;
	2048)
		cginum=70
	;;
	4096)
		cginum=100
	;;
	8192)
		cginum=130
	;;
    #add more options.
esac
cat <<EOF >/home/admin/runtime/php-fpm.conf
include=/home/bae/app/php_env.conf

[global]
pid = /var/run/bae/php-fpm.pid
error_log = /var/log/bae/php-fpm.log

[www]
user = bae
group = bae
listen = 127.0.0.1:9000

pm = dynamic
pm.max_children = $cginum
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = $cginum
pm.max_requests = 512

request_slowlog_timeout = 30

slowlog = /home/bae/log/slowlog.log

ping.path = /RUNTIME_CHECK.baev3
ping.response = ok


request_terminate_timeout = 30
EOF

exit 0
