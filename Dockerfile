FROM alpine:3.17

RUN apk --no-cache --update add quota-tools

COPY docker-entrypoint.sh /
COPY etc/cron.daily/rm-logs /etc/periodic/daily/

ENTRYPOINT ["/docker-entrypoint.sh"]
