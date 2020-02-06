# Laravel Base Images

These are a set of images with the needed dependencies installed without having to rebuild them every CI build.


## Arguments

### Install Flags

| Build Arg         | Default |
|-------------------|---------|
| INSTALL_BCMATH    | true    |
| INSTALL_CALENDAR  | false   |
| INSTALL_EXIF      | false   |
| INSTALL_GD        | true    |
| INSTALL_IMAGICK   | false   |
| INSTALL_MOSQUITTO | false   |
| INSTALL_MYSQL     | false   |
| INSTALL_PGSQL     | true    |
| INSTALL_REDIS     | false   |
| INSTALL_SQLSRV    | false   |
| INSTALL_XDEBUG    | false   |
| INSTALL_ZIP       | false   |

### Dependencies

| Build Arg | Description                              |
|-----------|------------------------------------------|
| DEPS      | Other dependencies to install from `apk` |
