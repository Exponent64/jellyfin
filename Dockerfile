FROM alpine:edge

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk -U upgrade \
    && apk add --no-cache jellyfin jellyfin-web jellyfin-ffmpeg libstdc++ \
    && rm -rf /var/cache/apk/*

RUN --network=none mkdir -p /config /cache /media /var/log/jellyfin
RUN --network=none chown -R jellyfin:jellyfin /config /cache /media /var/log/jellyfin /usr/share/webapps/jellyfin-web

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

USER jellyfin

EXPOSE 8096/tcp

CMD ["jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/cache", \
    "--logdir", "/var/log/jellyfin", \
    "--ffmpeg", "/usr/lib/jellyfin-ffmpeg/ffmpeg", \
    "--webdir", "/usr/share/webapps/jellyfin-web"]
