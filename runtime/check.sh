#!/bin/bash

ps auxf |grep -v grep | grep "^admin.*lighttpd .*" >/dev/null 2>&1
if [ $? -ne 0 ]; then
        echo "No lighttpd process is running" >&2
        exit 2
fi

ps auxf |grep -v grep | grep "^bae.*php-fpm.*" >/dev/null 2>&1
if [ $? -ne 0 ]; then
        echo "No php-fpm process is running" >&2
        exit 5
fi

exit 0
