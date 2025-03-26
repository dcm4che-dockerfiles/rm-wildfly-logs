FROM alpine:3.20.3

COPY docker-entrypoint.sh /
COPY etc/cron.daily/* /etc/periodic/daily/

ENTRYPOINT ["/docker-entrypoint.sh"]
