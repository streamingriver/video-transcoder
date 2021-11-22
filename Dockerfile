FROM ghcr.io/streamingriver/super-config:latest as superconfig
FROM ghcr.io/streamingriver/static-fileserver:latest as fileserver

FROM alpine:latest

RUN \
  apk add --update bash supervisor inotify-tools && \
  rm -rf /var/cache/apk/*

RUN mkdir -p /data/conf /data/run /data/logs
RUN chmod 711 /data/conf /data/run /data/logs

RUN mkdir -p /etc/supervisor/conf.d/

COPY supervisor.conf /data/conf

VOLUME ["/data"]
VOLUME ["/etc/supervisor/conf.d"]

COPY --from=mwader/static-ffmpeg:4.4.1 /ffmpeg  /ffmpeg
COPY --from=superconfig /super-config /super-config
COPY --from=fileserver /fileserver /fileserver

ENTRYPOINT ["supervisord","-n", "-c", "/data/conf/supervisor.conf"]
