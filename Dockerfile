FROM php:7.3-fpm-alpine

ONBUILD ARG bcmath
ONBUILD ARG exif
ONBUILD ARG gd
ONBUILD ARG imagick
ONBUILD ARG mosquitto
ONBUILD ARG mysql
ONBUILD ARG pgsql
ONBUILD ARG redis
ONBUILD ARG xdebug
ONBUILD ARG zip

ONBUILD RUN \
    if [ "$bcmath" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} bcmath" \
    ; fi \
    && if [ "$exif" = "true" ]; then \
        export DEPS="${DEPS} exiftool" \
        && export EXT_INSTALL="${EXT_INSTALL} exif" \
    ; fi \
    && if [ "$gd" = "true" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} gd" \
        && export BUILD_DEPS="${BUILD_DEPS} freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev" \
        && export DEPS="${DEPS} freetype libjpeg-turbo libpng libwebp" \
    ; fi \
    && if [ "$imagick" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} imagemagick-dev" \
        && export DEPS="${DEPS} imagemagick" \
        && PECLS="${PECLS} imagick" \
        && EXT_ENABLE="${EXT_ENABLE} imagick" \
    ; fi \
    && if [ "$mosquitto" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} mosquitto-dev" \
        && export DEPS="${DEPS} mosquitto-libs" \
        && export PECLS="${PECLS} Mosquitto-alpha" \
        && export EXT_ENABLE="${EXT_ENABLE} mosquitto" \
    ; fi \
    && if [ "$mysql" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} mysqli pdo_mysql" \
    ; fi \
    && if [ "$pgsql" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} pgsql pdo_pgsql" \
        && export BUILD_DEPS="${BUILD_DEPS} postgresql-dev" \
        && export DEPS="${DEPS} postgresql-client postgresql-libs" \
    ; fi \
    && if [ "$redis" = "true" ]; then \
        export PECLS="${PECLS} redis" \
        && export EXT_ENABLE="${EXT_ENABLE} redis" \
    ; fi \
    && if [ "$xdebug" = "true" ]; then \
        export PECLS="${PECLS} xdebug" \
        && export EXT_ENABLE="${EXT_ENABLE} xdebug" \
    ; fi \
    && if [ "$zip" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} libzip-dev" \
        && export DEPS="${DEPS} libzip zip" \
        && export EXT_INSTALL="${EXT_INSTALL} zip" \
    ; fi \
    && set -x \
    && apk add --virtual .build-deps $BUILD_DEPS $PHPIZE_DEPS \
    && apk add $DEPS fcgi nginx s6 \
    && if [ "$gd" = "true" ]; then \
        docker-php-ext-configure gd \
            --with-gd \
            --with-freetype-dir=/usr/include/ \
            --with-png-dir=/usr/include/ \
            --with-jpeg-dir=/usr/include/ \
            --with-webp-dir=/usr/include/ \
    ; fi \
    && if [ "$zip" = "true" ]; then \
        docker-php-ext-configure zip --with-libzip \
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
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* \
    && cd "$PHP_INI_DIR" \
    && sed -ri \
        -e 's/;(ping\.path)/\1/' \
        ../php-fpm.d/www.conf \
    && ln -s php.ini-production php.ini \
    && sed -ri \
        -e 's/^(expose_php).*$/\1 = Off/' \
        php.ini-production \
    && mkdir /run/nginx

