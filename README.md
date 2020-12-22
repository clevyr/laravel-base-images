# PHP Base Image

An enhanced version of the default [PHP Docker image](https://hub.docker.com/_/php) which can install PHP extensions without requiring manual dependency installation using [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) and installs a default nginx setup.


## Build Arguments

| Build Arg       | Description                                                                                                                                         |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `INSTALL`       | PHP extensions to install. See [here](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions) for available extensions. |
| `DEPS`          | `apk` dependencies to install during the build.                                                                                                     |

### Nginx Configuration

Some nginx values can be configured as a build arg.

| Build Arg       | Nginx Directive                                                               | Default       |
|-----------------|-------------------------------------------------------------------------------|---------------|
| `NGINX_ROOT`    | [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root)          | `/app/public` |
| `NGINX_EXPIRES` | [expires](http://nginx.org/en/docs/http/ngx_http_headers_module.html#expires) | `7d`          |

### PHP Configuration

Some php.ini values can be configured as a build arg.

| Build Arg                      | `php.ini` Directive                                                                               | Default |
|--------------------------------|---------------------------------------------------------------------------------------------------|---------|
| `PHP_CONF_MAX_EXECUTION_TIME`  | [max_execution_time](https://www.php.net/manual/en/info.configuration.php#ini.max-execution-time) | `30`    |
| `PHP_CONF_MAX_INPUT_VARS`      | [max_input_vars](https://www.php.net/manual/en/info.configuration.php#ini.max-input-vars)         | `1000`  |
| `PHP_CONF_MEMORY_LIMIT`        | [memory_limit](https://www.php.net/manual/en/ini.core.php#ini.memory-limit)                       | `256M`  |
| `PHP_CONF_POST_MAX_SIZE`       | [post_max_size](https://www.php.net/manual/en/ini.core.php#ini.post-max-size)                     | `32M`   |
| `PHP_CONF_UPLOAD_MAX_FILESIZE` | [upload_max_filesize](https://www.php.net/manual/en/ini.core.php#ini.upload-max-filesize)         | `8M`    |

### Legacy Build Arguments

These are the legacy build args. They will still be supported for the forseeable future, but they are not as powerful as the new `INSTALL` build arg, so if you are creating an app from scratch, the `INSTALL` build arg may be more useful for you. These are also convenient because they group up some extensnions. For example, if you set `INSTALL_MYSQL=true`, then both `mysqli` and `pdo_mysql` will be installed.

| Build Arg           | Default   |
|---------------------|-----------|
| `INSTALL_BCMATH`    | `true`    |
| `INSTALL_CALENDAR`  | `false`   |
| `INSTALL_EXIF`      | `false`   |
| `INSTALL_GD`        | `true`    |
| `INSTALL_IMAGICK`   | `false`   |
| `INSTALL_INTL`      | `false`   |
| `INSTALL_MOSQUITTO` | `false`   |
| `INSTALL_MYSQL`     | `false`   |
| `INSTALL_PGSQL`     | `true`    |
| `INSTALL_REDIS`     | `false`   |
| `INSTALL_XDEBUG`    | `false`   |
| `INSTALL_ZIP`       | `false`   |
