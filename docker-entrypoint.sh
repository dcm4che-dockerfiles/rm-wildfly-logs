#!/bin/sh

if [ "$#" -lt 1 ]; then
    echo \
"Usage: docker run -v WILDFLY_SERVER_LOG_DIR_ON_HOST:WILDFLY_SERVER_LOG_DIR_IN_CONTAINER \\
                  -d dcm4che/rm-wildfly-logs WILDFLY_SERVER_LOG_DIR_IN_CONTAINER"
    exit
fi

run-parts --exit-on-error /etc/init.d

# start cron
WILDFLY_SERVER_LOG_DIR="$1" /usr/sbin/crond -f
