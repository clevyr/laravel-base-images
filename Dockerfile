FROM php:7.4-fpm-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer

ONBUILD ARG INSTALL_BCMATH
ONBUILD ARG INSTALL_EXIF
ONBUILD ARG INSTALL_GD
ONBUILD ARG INSTALL_IMAGICK
ONBUILD ARG INSTALL_MOSQUITTO
ONBUILD ARG INSTALL_MYSQL
ONBUILD ARG INSTALL_PGSQL
ONBUILD ARG INSTALL_REDIS
ONBUILD ARG INSTALL_XDEBUG
ONBUILD ARG INSTALL_ZIP
ONBUILD ARG DEPS

ONBUILD RUN \
    if [ "$INSTALL_BCMATH" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} bcmath" \
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
    && if [ "$INSTALL_MOSQUITTO" = "true" ]; then \
        export BUILD_DEPS="${BUILD_DEPS} mosquitto-dev" \
        && export DEPS="${DEPS} mosquitto-libs" \
        && export PECLS="${PECLS} Mosquitto-alpha" \
        && export EXT_ENABLE="${EXT_ENABLE} mosquitto" \
    ; fi \
    && if [ "$INSTALL_MYSQL" != "false" ]; then \
        export EXT_INSTALL="${EXT_INSTALL} mysqli pdo_mysql" \
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
    && apk add $DEPS fcgi nginx s6 \
    && if [ "$INSTALL_GD" = "true" ]; then \
        docker-php-ext-configure gd \
    ; fi \
    && if [ "$INSTALL_ZIP" = "true" ]; then \
        docker-php-ext-configure zip \
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

