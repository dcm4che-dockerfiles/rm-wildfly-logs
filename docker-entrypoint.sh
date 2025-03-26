#!/bin/sh

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "help" ]; then
    printf \
"Provide cron service for daily deletion of WildFly Server log files

Usage: docker run -v /host/log-dir1:/log-dir1 -v /host/log-dir2:/log-dir2
                  -d dcm4che/rm-wildfly-logs /log-dir1 /log-dir2

with

'-v /host/log-dir1:/log-dir1 -v /host/log-dir2:/log-dir2'

to bind mount WildFly Server directories on the docker host containing server
log files into the container. The directory path(s) inside the container must
match with the passed argument(s):

'/log-dir1 /log-dir2'.

Alternatively of specifying the directory path(s) by passed argument(s) they
may be specifying by Environment Variable:

WILDFLY_SERVER_LOG_DIRS - space separated directory paths containing WildFly
server log files.

The number of days after which log files are deleted can be configured by
Environment Variables:

WILDFLY_SERVER_LOG_RETENTION_DAYS - number of days after which 'server.log*'
files in specified directories are deleted, 7 days by default.

WILDFLY_AUDIT_LOG_RETENTION_DAYS - number of days after which 'audit-log.log*'
files in specified directories are deleted, 7 days by default.

WILDFLY_ACCESS_LOG_RETENTION_DAYS - number of days after which 'access_log.*'
files in specified directories are deleted, 7 days by default.

The cron service may also be used for daily deletion of logged HL7 messages of
dcm4chee archive instances by bind mount directories containing logged HL7 messages
into the container and passing the directory path(s) inside the container by
Environment Variable:

ARC_HL7_LOG_DIRS - space separated directory paths of logged HL7 messages of
dcm4chee archive instances

ARC_HL7_LOG_RETENTION_DAYS - number of days after which '*.hl7' files in
directories specified by ARC_HL7_LOG_DIRS are deleted, 7 days by default.

Executable scripts bind mounted into the container under '/init.d' will be
executed in lexical sort order at each container startup and may be used to
configure cron to run (additionally) other tasks periodically.
"
    exit
fi

if [ -d "/etc/init.d" ]; then
    run-parts --exit-on-error /etc/init.d
fi

# start cron
WILDFLY_SERVER_LOG_DIRS=${WILDFLY_SERVER_LOG_DIRS:-$*} /usr/sbin/crond -f
