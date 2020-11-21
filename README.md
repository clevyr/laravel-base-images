# PHP Base Image

An enhanced version of the default [PHP Docker image](https://hub.docker.com/_/php) which can install PHP extensions without requiring manual dependency installation using [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) and installs a default nginx setup.


## Arguments

| Build Arg | Description                                                                                                                                         |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `INSTALL` | PHP extensions to install. See [here](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions) for available extensions. |
| `DEPS`    | `apk` dependencies to install during the build.                                                                                                     |
