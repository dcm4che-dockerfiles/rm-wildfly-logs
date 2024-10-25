#!/bin/sh

if [ "$1" = "-h" -o "$1" = "--help" ]; then
    echo \
"Provide cron service for daily deletion of Wildfly server log files

Usage: docker run -v /host/log-dir1:/log-dir1 -v /host/log-dir2:/log-dir2
                  -d dcm4che/rm-wildfly-logs /log-dir1 /log-dir2

with

'-v /host/log-dir1:/log-dir1 -v /host/log-dir2:/log-dir2'

to bind mount WildFly Server directories on the docker host containing server
log files into the container. The directory path(s) inside the container must
match with the passed argument(s):

'/log-dir1 /log-dir2'.

The number of days after which log files are deleted can be configured by
Environment Variables:

WILDFLY_SERVER_LOG_RETENTION_DAYS - number of days after which 'server.log*'
files in specified directories are deleted, 7 days by default.

WILDFLY_AUDIT_LOG_RETENTION_DAYS - number of days after which 'audit-log.log*'
files in specified directories are deleted, 7 days by default.

Excutable scripts bind mounted into the container under '/init.d' will be
executed in lexical sort order at each container startup and may be used to
configure cron to run (additionally) other tasks periodically.

E.g.:

$ docker run -v /host/init.d:/init.d -d dcm4che/rm-wildfly-logs

with executable

$ cat /host/init.d/get-used-blocks
#!/bin/sh

if [ ! -f \$0.done ]; then
  crontab -l \\
  | sed \"$ i */1\t*\t*\t*\t*\tquota -w \\
  | sed -n '\%fs1%p' \\
  | cut -f2 -d ' ' > /used-blocks/fs1\" \\
  | crontab -
  touch \$0.done
fi

will query the number of used blocks of a filesystem every minute and
write it to a file."
    exit
fi

run-parts --exit-on-error /etc/init.d

# start cron
WILDFLY_SERVER_LOG_DIRS=$@ /usr/sbin/crond -f