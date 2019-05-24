FROM jsimonetti/alpine-edge:latest

ENV UID=991 GID=991 UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M

RUN echo "@community https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk add --no-cache -t build-dependencies \
    wget \
 && apk add --no-cache \
    ca-certificates \
    nginx \
    s6 \
    su-exec \
    php7-fpm \
    php7-curl \
    php7-iconv \
    php7-xml \
    php7-dom \
    php7-openssl \
    php7-json \
    php7-zlib \
    php7-pdo_pgsql \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-sqlite3 \
    php7-ldap \
    php7-simplexml \
 && cd /tmp \
 && wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip \
 && mkdir /rainloop && unzip -q /tmp/rainloop-community-latest.zip -d /rainloop \
 && find /rainloop -type d -exec chmod 755 {} \; \
 && find /rainloop -type f -exec chmod 644 {} \; \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/*

COPY rootfs /
RUN chmod +x /start.sh /services/*/run /services/.s6-svscan/*
VOLUME /rainloop/data
EXPOSE 8888
CMD ["/start.sh"]
