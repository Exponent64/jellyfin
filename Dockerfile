FROM alpine:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

RUN apk -U upgrade \
    && apk add --no-cache jellyfin jellyfin-web jellyfin-ffmpeg libstdc++ \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /var/lib/jellyfin \
    /var/cache/jellyfin \
    /var/log/jellyfin \
    /usr/share/webapps/jellyfin-web \
    /media

RUN chown -R jellyfin:jellyfin \
    /var/lib/jellyfin \
    /var/cache/jellyfin \
    /var/log/jellyfin \
    /usr/share/webapps/jellyfin-web \
    /media

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

RUN sed -i 's/--nowebclient//g' /etc/conf.d/jellyfin

USER jellyfin

EXPOSE 8096/tcp

CMD ["jellyfin"]
