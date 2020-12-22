# PHP Base Image

An enhanced version of the default [PHP Docker image](https://hub.docker.com/_/php) which can install PHP extensions without requiring manual dependency installation using [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) and installs a default nginx setup.


## Build Arguments

| Build Arg       | Description                                                                                                                                         |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `INSTALL`       | PHP extensions to install. See [here](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions) for available extensions. |
| `DEPS`          | `apk` dependencies to install during the build.                                                                                                     |
| `NGINX_ROOT`    | The root directory that nginx should serve. Defaults to `/app/public`.                                                                              |
| `NGINX_EXPIRES` | The length of time nginx should allow clients to keep static assets cached. Defaults to `7d`.                                                       |

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
