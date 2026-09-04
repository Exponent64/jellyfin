ARG UID=200017
ARG GID=200017

FROM alpine:latest

ARG UID
ARG GID

RUN echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

RUN apk -U upgrade \
    && apk add --no-cache jellyfin jellyfin-web jellyfin-ffmpeg libstdc++ \
    && rm -rf /var/cache/apk/*

RUN --network=none \
    addgroup -g ${GID} jellyfin \
    && adduser -u ${UID} --ingroup jellyfin --disabled-password --system jellyfin

RUN mkdir -p /config /cache /media
RUN chown -R jellyfin:jellyfin /config /cache /media /usr/share/webapps/jellyfin-web

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

USER jellyfin

EXPOSE 8096/tcp

CMD ["jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/cache", \
    "--ffmpeg", "/usr/lib/jellyfin-ffmpeg/ffmpeg", \
    "--webdir", "/usr/share/webapps/jellyfin-web"]
