FROM alpine:3.20.3

RUN apk --no-cache --update add quota-tools

COPY docker-entrypoint.sh /
COPY etc/cron.daily/* /etc/periodic/daily/

ENTRYPOINT ["/docker-entrypoint.sh"]
