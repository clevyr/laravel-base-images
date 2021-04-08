ARG PHP_VERSION=8.0
ARG ALPINE_VERSION=3.12
FROM php:$PHP_VERSION-fpm-alpine$ALPINE_VERSION

ENV LC_ALL=C

WORKDIR /app

RUN set -x \
    && apk add --no-cache \
        bash \
        fcgi \
        gettext \
        git \
        nginx \
        s6 \
        su-exec \
    && cd "$PHP_INI_DIR" \
    && sed -ri \
        -e 's/^(access.log)/;\1/' \
        ../php-fpm.d/docker.conf \
    && sed -ri \
        -e 's/;(ping\.path)/\1/' \
        ../php-fpm.d/www.conf \
    && ln -s php.ini-production php.ini \
    && mkdir /run/nginx \
    && sed -ri \
        -e 's/#(tcp_nopush on;)/\1/' \
        /etc/nginx/nginx.conf \
    && sed -ri \
        -e '$ s/(})/    application\/wasm wasm;\n\1/' \
        /etc/nginx/mime.types

COPY --from=composer:1 /usr/bin/composer /usr/bin/composer1
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer2
RUN ln -s composer2 /usr/bin/composer
ARG COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=$COMPOSER_MEMORY_LIMIT

COPY --from=clevyr/prestissimo /tmp /root/.composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

COPY rootfs/ /

ENV XDEBUG_MODE="debug"
ENV XDEBUG_CONFIG="client_host=host.docker.internal client_port=9000 start_with_request=trigger"

CMD ["s6-svscan", "/etc/services.d"]

ONBUILD ARG SKIP_BUILD
ONBUILD ARG DEPS
ONBUILD ARG INSTALL

ONBUILD ARG INSTALL_BCMATH
ONBUILD ARG INSTALL_CALENDAR
ONBUILD ARG INSTALL_EXIF
ONBUILD ARG INSTALL_GD
ONBUILD ARG INSTALL_IMAGICK
ONBUILD ARG INSTALL_INTL
ONBUILD ARG INSTALL_MOSQUITTO
ONBUILD ARG INSTALL_MYSQL
ONBUILD ARG INSTALL_OPCACHE
ONBUILD ARG INSTALL_PGSQL
ONBUILD ARG INSTALL_REDIS
ONBUILD ARG INSTALL_SQLSRV
ONBUILD ARG INSTALL_XDEBUG
ONBUILD ARG INSTALL_ZIP

ONBUILD ARG NGINX_ROOT
ONBUILD ARG NGINX_EXPIRES

ONBUILD ARG PHP_CONF_MAX_EXECUTION_TIME
ONBUILD ARG PHP_CONF_MAX_INPUT_VARS
ONBUILD ARG PHP_CONF_MEMORY_LIMIT
ONBUILD ARG PHP_CONF_POST_MAX_SIZE
ONBUILD ARG PHP_CONF_UPLOAD_MAX_FILESIZE

ONBUILD RUN \
    if [ "$SKIP_BUILD" != "true" ]; then \
        clevyr-build \
    ; fi
