FROM php:7.4-fpm-alpine

ENV LC_ALL=C

WORKDIR /app
VOLUME /app

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=clevyr/prestissimo /tmp /root/.composer

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
ONBUILD ARG DEPS

ONBUILD RUN \
    if [ "$INSTALL_BCMATH" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} bcmath" \
    ; fi \
    && if [ "$INSTALL_CALENDAR" = "true" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} calendar" \
    ; fi \
    && if [ "$INSTALL_EXIF" = "true" ]; then \
        export DEPS="${DEPS} exiftool" \
        && export EXT_INSTALL="${EXT_INSTALL} exif" \
    ; fi \
    && if [ "$INSTALL_GD" = "true" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} gd" \
        && export BUILD_DEPS="${BUILD_DEPS} freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev" \
        && export DEPS="${DEPS} freetype libjpeg-turbo libpng libwebp" \
    ; fi \
    && if [ "$INSTALL_IMAGICK" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} imagemagick-dev" \
        && export DEPS="${DEPS} imagemagick" \
        && PECLS="${PECLS} imagick" \
        && EXT_ENABLE="${EXT_ENABLE} imagick" \
    ; fi \
    && if [ "$INSTALL_INTL" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} icu-dev" \
        export DEPS="${DEPS} icu-libs" \
        export EXT_INSTALL="${EXT_INSTALL} intl" \
    ; fi \
    && if [ "$INSTALL_MOSQUITTO" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} mosquitto-dev" \
        && export DEPS="${DEPS} mosquitto-libs" \
        && export PECLS="${PECLS} Mosquitto-alpha" \
        && export EXT_ENABLE="${EXT_ENABLE} mosquitto" \
    ; fi \
    && if [ "$INSTALL_MYSQL" = "true" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} mysqli pdo_mysql" \
    ; fi \
    && if [ "$INSTALL_OPCACHE" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} opcache" \
    ; fi \
    && if [ "$INSTALL_PGSQL" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} pgsql pdo_pgsql" \
        && export BUILD_DEPS="${BUILD_DEPS} postgresql-dev" \
        && export DEPS="${DEPS} postgresql-client postgresql-libs" \
    ; fi \
    && if [ "$INSTALL_REDIS" = "true" ]; then \
        export PECLS="${PECLS} redis" \
        && export EXT_ENABLE="${EXT_ENABLE} redis" \
    ; fi \
    && if [ "$INSTALL_SQLSRV" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} unixodbc-dev" \
        && export PECLS="${PECLS} pdo_sqlsrv" \
        && export EXT_ENABLE="${EXT_ENABLE} pdo_sqlsrv" \
    ; fi \
    && if [ "$INSTALL_XDEBUG" = "true" ]; then \
        export PECLS="${PECLS} xdebug" \
        && export EXT_ENABLE="${EXT_ENABLE} xdebug" \
    ; fi \
    && if [ "$INSTALL_ZIP" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} libzip-dev" \
        && export DEPS="${DEPS} libzip zip" \
        && export EXT_INSTALL="${EXT_INSTALL} zip" \
    ; fi \
    && set -x \
    && apk add --virtual .build-deps $BUILD_DEPS $PHPIZE_DEPS \
    && apk add $DEPS fcgi git nginx s6 \
    && docker-php-source extract \
    && if [ "$INSTALL_GD" = "true" ]; then \
        docker-php-ext-configure gd \
            --with-freetype=/usr/include/ \
            --with-jpeg=/usr/include/ \
            --with-webp=/usr/include/ \
    ; fi \
    && if [ "$INSTALL_SQLSRV" = "true" ]; then \
        mkdir /tmp/mssql \
        && cd /tmp/mssql \
        && curl -Osf https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.5.1.1-1_amd64.apk \
        && curl -Osf https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.5.1.2-1_amd64.apk \
        && apk add --no-cache --allow-untrusted \
            msodbcsql17_17.5.1.1-1_amd64.apk mssql-tools_17.5.1.2-1_amd64.apk \
        && cd - \
        && rm -rf /tmp/mssql \
    ; fi \
    && if [ -n "$EXT_INSTALL" ]; then \
        docker-php-ext-install -j"$(nproc)" $EXT_INSTALL \
    ; fi \
    && if [ -n "$PECLS" ]; then \
        pecl install $PECLS \
    ; fi \
    && if [ -n "$EXT_ENABLE" ]; then \
        docker-php-ext-enable $EXT_ENABLE \
    ; fi \
    && docker-php-source delete \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* \
    && cd "$PHP_INI_DIR" \
    && sed -ri \
        -e 's/^(access.log)/;\1/' \
        ../php-fpm.d/docker.conf \
    && sed -ri \
        -e 's/;(ping\.path)/\1/' \
        ../php-fpm.d/www.conf \
    && ln -s php.ini-production php.ini \
    && sed -ri \
        -e 's/^(expose_php).*$/\1 = Off/' \
        -e 's/^(memory_limit).*$/\1 = 256M/' \
        php.ini \
    && mkdir /run/nginx

