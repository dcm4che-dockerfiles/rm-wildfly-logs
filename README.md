This docker image provides a cron service for daily deletion of Wildfly server log files
Optionally also other tasks can be scheduled for periodical executions

# How to use this image

## start an instance

E.g.:
```
$ docker run -v /var/local/dcm4chee-arc/wildfly/log:/wildfly-log \
             -v /var/local/dcm4chee-arc/rm-wildfly-logs/init.d:/etc/init.d \
             -d dcm4che/rm-wildfly-logs /wildfly-log
```

with
```
-v /var/local/dcm4chee-arc/wildfly/log:/wildfly-log
```
bind mount the Wildfly directory on the docker host containing server log files into the container. The path must
match with the passed argument `/wildfly-log`

Optional
```
             -v /var/local/dcm4chee-arc/rm-wildfly-logs/init.d:/etc/init.d \
```
bind mount a host directory containing executable files into the container at `/etc/init.d`, which are run on each
container start in lexical sort order. You may wrap statements which shall only be invoked on first container
startup by
```bash
#!/bin/sh

if [ ! -f $0.done ]; then
  crontab -l | sed "$ i */1\t*\t*\t*\t*\tquota -w | sed -n '\%fs1%p'  | cut -f2 -d ' ' > /quota/fs1" | crontab -
  touch $0.done
fi
```

## Environment Variables

#### `WILDFLY_SERVER_LOG_RETENTION_DAYS`)

Delete `server.log*` files in specified directory older than specified number of days automatically
(optional, default is `7`).

#### `WILDFLY_AUDIT_LOG_RETENTION_DAYS`

Delete `audit-log.log*` files in specified directory older than specified number of days automatically
(optional, default is `7`).
