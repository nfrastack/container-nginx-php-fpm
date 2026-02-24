# nfrastack/container-nginx-php-fpm

## About

This repository will build a [Nginx](https://www.nginx.org) w/[PHP-FPM](https://php.net) container image, suitable for serving PHP scripts, or utilizing as a base image for installing additional software.

* Tracking PHP 5.3-8.5
* Easily enable / disable extensions based on your use case
* Automatic Log rotation
* Composer Included
* XDebug capability
* Caching via APC, opcache
* Includes client libraries for [MariaDB](https://www.mariadb.org) and [Postgresql](https://www.postgresql.org)
* Multiple pool support

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-nginx-php-fpm/pkgs/container/container-nginx-php-fpm) and [Docker Hub](https://hub.docker.com/r/nfrastack/nginx-php-fpm).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-nginx-php-fpm:(image_tag)
docker.io/nfrastack/nginx-php-fpm:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional phpversion>-<optional distro>-<optional distro_variant>`

Example:

`ghcr.io/nfrastack/container-nginx-php-fpm:latest` or

`ghcr.io/nfrastack/container-nginx-php-fpm:1.0-8.4-debian_trixie`

* `latest` will be the most recent commit

* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest

| PHP version | Alpine Base | Tag            | Debian Base | Tag                    |
| ----------- | ----------- | -------------- | ----------- | ---------------------- |
| latest      | edge        | `:alpine-edge` |             |                        |
| 8.5.x       | 3.23        | `:8.5-alpine`  |             |                        |
| 8.4.x       | 3.23        | `:8.4-alpine`  | Trixie      | `:8.4-debian`          |
|             |             |                | Bookworm    | `:8.4-debian_bookworm` |
| 8.3.x       | 3.23        | `:8.3-alpine`  | Bookworm    | `:8.3-debian_trixie`   |
|             |             |                | Trixie      | `:8.3-debian`          |
| 8.2.x       | 3.22        | `:8.2-alpine`  | Trixie      | `:8.2-debian`          |
|             |             |                | Bookworm    | `:8.2-debian_bookworm` |
| 8.1.x       | 3.19        | `:8.1-alpine`  |             |                        |
| 8.0.x       | 3.16        | `:8.0-alpine`  |             |                        |


Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

Refer to the nginx upstream readme for configuration. If you do not create any configuration files for the sites, a default PHP location block will be added to your site

```nginx
location ~ [^/]\.php(/|$) {
    try_files $fastcgi_script_name =404; # Fail if script missing
    {{php_upstream}};
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_index {{php_index_file}};
    {{fastcgi_params}};
}
```

{{php_upstream}} will get replaced on container start with your PHP POOL value, and {{fastcgi_params}} will get replaced with the location of your nginx fastcgi_params.

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Directory       | Description                |
| --------------- | -------------------------- |
| `/www/html`     | Root Directory             |
| `/logs/php-fpm` | Nginx and php-fpm logfiles |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description     |
| ------------------------------------------------------- | --------------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image      |
| [Nginx](https://github.com/nfrastack/container-nginx/)  | Nginx Webserver |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Variable                | Description                         | Default                             |
| ----------------------- | ----------------------------------- | ----------------------------------- |
| `ENABLE_PHP_FPM`        | Enable PHP-FPM container mode       | `TRUE`                              |
| `PHPFPM_CONTAINER_MODE` | Container mode for PHP-FPM          | `nginx-php-fpm`                     |
| `PHP_CREATE_SAMPLE_PHP` | Create a sample PHP page on startup | `TRUE`                              |
| `PHP_HIDE_X_POWERED_BY` | Hide X-Powered-By header            | `TRUE`                              |
| `PHP_KITCHENSINK`       | Enable all PHP extensions           | `FALSE`                             |
| `PHP_MEMORY_LIMIT`      | PHP memory limit                    | `128M`                              |
| `PHP_POST_MAX_SIZE`     | Maximum POST size                   | `2G`                                |
| `PHP_TIMEOUT`           | Script execution timeout            | `180`                               |
| `PHP_UPLOAD_MAX_SIZE`   | Maximum upload size                 | `2G`                                |
| `PHP_WEBROOT`           | Webroot directory                   | `/www/html` (or `${NGINX_WEBROOT}`) |

#### PHP Environment

| Variable            | Description              | Default                                                        |
| ------------------- | ------------------------ | -------------------------------------------------------------- |
| `PHPFPM_ENV_TEMP`   | PHP-FPM temp directory   | `/tmp`                                                         |
| `PHPFPM_ENV_TMP`    | PHP-FPM tmp directory    | `/tmp`                                                         |
| `PHPFPM_ENV_TMPDIR` | PHP-FPM tmpdir           | `/tmp`                                                         |
| `PHPFPM_ENV_PATH`   | PHP-FPM PATH environment | `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` |

#### PHP Pools

You can define multiple PHP-FPM pools using environment variables. The default pool uses variables prefixed with `PHPFPM_POOL_DEFAULT_`. To add additional pools, use the pattern:

`PHPFPM_POOL_<POOLNAME>_<SETTING>`

For example, to add a pool named `api`:

```env
PHPFPM_POOL_API_LISTEN_TYPE=tcp
PHPFPM_POOL_API_LISTEN_TCP_PORT=9001
PHPFPM_POOL_API_USER=www-data
PHPFPM_POOL_API_GROUP=www-data
```

Each pool will be configured in `/etc/php.../pools.d/<poolname>.conf` inside the container.

If no pool is defined then a default `www` pool will be created with the following default settings

Default pool settings:

| Variable                                      | Description                        | Default                             |
| --------------------------------------------- | ---------------------------------- | ----------------------------------- |
| `PHPFPM_POOL_DEFAULT_LISTEN_UNIX_GROUP`       | Default UNIX group for pool        | `${NGINX_GROUP}`                    |
| `PHPFPM_POOL_DEFAULT_LISTEN_UNIX_USER`        | Default UNIX user for pool         | `${NGINX_USER}`                     |
| `PHPFPM_POOL_DEFAULT_USER`                    | Default pool user                  | `${NGINX_USER}`                     |
| `PHPFPM_POOL_DEFAULT_GROUP`                   | Default pool group                 | `${NGINX_GROUP}`                    |
| `PHPFPM_POOL_DEFAULT_CATCH_WORKERS_OUTPUT`    | Catch workers output               | `true`                              |
| `PHPFPM_POOL_DEFAULT_ENABLE_LOG`              | Enable pool logging                | `TRUE`                              |
| `PHPFPM_POOL_DEFAULT_PING_PATH`               | Pool ping path                     | `/ping`                             |
| `PHPFPM_POOL_DEFAULT_DISPLAY_ERRORS`          | Display errors                     | `TRUE`                              |
| `PHPFPM_POOL_DEFAULT_LISTEN_IP`               | Pool listen IP                     | `0.0.0.0`                           |
| `PHPFPM_POOL_DEFAULT_LISTEN_TYPE`             | Pool listen type                   | `unix`                              |
| `PHPFPM_POOL_DEFAULT_LISTEN_PORT`             | Pool listen port                   | `9000`                              |
| `PHPFPM_POOL_DEFAULT_LISTEN_TCP_IP`           | Pool listen TCP IP                 | `0.0.0.0`                           |
| `PHPFPM_POOL_DEFAULT_LISTEN_TCP_IP_ALLOWED`   | Allowed TCP IPs                    | `127.0.0.1`                         |
| `PHPFPM_POOL_DEFAULT_LISTEN_TCP_PORT`         | Pool listen TCP port               | `9000`                              |
| `PHPFPM_POOL_DEFAULT_LISTEN_UNIX_SOCKET`      | Pool UNIX socket                   | `/var/lib/php-fpm/run/default.sock` |
| `PHPFPM_POOL_DEFAULT_ENV`                     | Default pool environment variables | `PATH,TEMP,TMP,TMPDIR`              |
| `PHPFPM_POOL_DEFAULT_LOG_ACCESS_FILE`         | Pool access log file               | `default-access.log`                |
| `PHPFPM_POOL_DEFAULT_LOG_ACCESS_FORMAT`       | Pool access log format             | `default`                           |
| `PHPFPM_POOL_DEFAULT_LOG_PATH`                | Pool log path                      | `/logs/php-fpm/`                    |
| `PHPFPM_POOL_DEFAULT_MAX_CHILDREN`            | Max children                       | `75`                                |
| `PHPFPM_POOL_DEFAULT_MAX_INPUT_NESTING_LEVEL` | Max input nesting level            | `256`                               |
| `PHPFPM_POOL_DEFAULT_MAX_INPUT_VARS`          | Max input vars                     | `10000`                             |
| `PHPFPM_POOL_DEFAULT_MAX_REQUESTS`            | Max requests                       | `0`                                 |
| `PHPFPM_POOL_DEFAULT_MAX_SPARE_SERVERS`       | Max spare servers                  | `3`                                 |
| `PHPFPM_POOL_DEFAULT_MEMORY_LIMIT`            | Pool memory limit                  | `${PHP_MEMORY_LIMIT}`               |
| `PHPFPM_POOL_DEFAULT_MIN_SPARE_SERVERS`       | Min spare servers                  | `1`                                 |
| `PHPFPM_POOL_DEFAULT_OUTPUT_BUFFER_SIZE`      | Output buffer size                 | `0`                                 |
| `PHPFPM_POOL_DEFAULT_POST_MAX_SIZE`           | Pool POST max size                 | `${PHP_POST_MAX_SIZE}`              |
| `PHPFPM_POOL_DEFAULT_PROCESS_IDLE_TIMEOUT`    | Process idle timeout               | `10s`                               |
| `PHPFPM_POOL_DEFAULT_PROCESS_MANAGER`         | Process manager                    | `dynamic`                           |
| `PHPFPM_POOL_DEFAULT_START_SERVERS`           | Start servers                      | `2`                                 |
| `PHPFPM_POOL_DEFAULT_STATUS_PATH`             | Status path                        | `/php-fpm_status`                   |
| `PHPFPM_POOL_DEFAULT_TIMEOUT`                 | Pool timeout                       | `${PHP_TIMEOUT}`                    |
| `PHPFPM_POOL_DEFAULT_UPLOAD_MAX_SIZE`         | Pool upload max size               | `${PHP_UPLOAD_MAX_SIZE}`            |

#### Logging

| Variable                | Description    | Default             |
| ----------------------- | -------------- | ------------------- |
| `PHPFPM_LOG_ERROR_FILE` | Error log file | `error.log`         |
| `PHPFPM_LOG_ERROR_PATH` | Error log path | `/var/log/php-fpm/` |
| `PHPFPM_LOG_LEVEL`      | Log level      | `notice`            |
| `PHPFPM_LOG_LIMIT`      | Log limit      | `3072`              |

### Modules

#### Enabling / Disabling Specific Modules

Enable extensions by using the PHP extension name ie redis as `PHP_MODULE_ENABLE_REDIS=TRUE`. Core extensions are enabled by default are:

| Parameter                     | Default |
| ----------------------------- | ------- |
| `PHP_MODULE_ENABLE_APCU`      | `TRUE`  |
| `PHP_MODULE_ENABLE_BCMATH`    | `TRUE`  |
| `PHP_MODULE_ENABLE_BZ2`       | `TRUE`  |
| `PHP_MODULE_ENABLE_CTYPE`     | `TRUE`  |
| `PHP_MODULE_ENABLE_CURL`      | `TRUE`  |
| `PHP_MODULE_ENABLE_DOM`       | `TRUE`  |
| `PHP_MODULE_ENABLE_EXIF`      | `TRUE`  |
| `PHP_MODULE_ENABLE_FILEINFO`  | `TRUE`  |
| `PHP_MODULE_ENABLE_GD`        | `TRUE`  |
| `PHP_MODULE_ENABLE_ICONV`     | `TRUE`  |
| `PHP_MODULE_ENABLE_IMAP`      | `TRUE`  |
| `PHP_MODULE_ENABLE_INTL`      | `TRUE`  |
| `PHP_MODULE_ENABLE_JSON`      | `TRUE`  |
| `PHP_MODULE_ENABLE_MBSTRING`  | `TRUE`  |
| `PHP_MODULE_ENABLE_MYSQLI`    | `TRUE`  |
| `PHP_MODULE_ENABLE_MYSQLND`   | `TRUE`  |
| `PHP_MODULE_ENABLE_OPCACHE`   | `TRUE`  |
| `PHP_MODULE_ENABLE_OPENSSL`   | `TRUE`  |
| `PHP_MODULE_ENABLE_PDO`       | `TRUE`  |
| `PHP_MODULE_ENABLE_PDO_MYSQL` | `TRUE`  |
| `PHP_MODULE_ENABLE_PGSQL`     | `TRUE`  |
| `PHP_MODULE_ENABLE_PHAR`      | `TRUE`  |
| `PHP_MODULE_ENABLE_SESSION`   | `TRUE`  |
| `PHP_MODULE_ENABLE_SIMPLEXML` | `TRUE`  |
| `PHP_MODULE_ENABLE_TOKENIZER` | `TRUE`  |
| `PHP_MODULE_ENABLE_XML`       | `TRUE`  |
| `PHP_MODULE_ENABLE_XMLREADER` | `TRUE`  |
| `PHP_MODULE_ENABLE_XMLWRITER` | `TRUE`  |

To enable all modules in image use `PHP_KITCHENSINK=TRUE`. Head inside the image and see what extensions are available by typing `php-ext list all`

###### APCu Options

| Variable                  | Description             | Default |
| ------------------------- | ----------------------- | ------- |
| `PHP_MODULE_APC_SHM_SIZE` | APCu shared memory size | `128M`  |
| `PHP_MODULE_APC_TTL`      | APCu time to live       | `7200`  |

###### OPCache Options

| Variable                                     | Description                     | Default     |
| -------------------------------------------- | ------------------------------- | ----------- |
| `PHP_MODULE_OPCACHE_MEM_SIZE`                | Opcache memory size             | `128`       |
| `PHP_MODULE_OPCACHE_INTERNED_STRINGS_BUFFER` | Opcache interned strings buffer | `8`         |
| `PHP_MODULE_OPCACHE_JIT_BUFFER_SIZE`         | Opcache JIT buffer size         | `50M`       |
| `PHP_MODULE_OPCACHE_JIT_MODE`                | Opcache JIT mode                | `1255`      |
| `PHP_MODULE_OPCACHE_MAX_ACCELERATED_FILES`   | Opcache max accelerated files   | `10000`     |
| `PHP_MODULE_OPCACHE_MAX_FILE_SIZE`           | Opcache max file size           | `0`         |
| `PHP_MODULE_OPCACHE_MAX_WASTED_PERCENTAGE`   | Opcache max wasted percentage   | `5`         |
| `PHP_MODULE_OPCACHE_OPTIMIZATION_LEVEL`      | Opcache optimization level      | `0x7FFFBFF` |
| `PHP_MODULE_OPCACHE_REVALIDATE_FREQ`         | Opcache revalidate frequency    | `2`         |
| `PHP_MODULE_OPCACHE_SAVE_COMMENTS`           | Opcache save comments           | `1`         |
| `PHP_MODULE_OPCACHE_VALIDATE_TIMESTAMPS`     | Opcache validate timestamps     | `1`         |

###### XDebug Options

To enable XDebug set `PHP_MODULE_ENABLE_XDEBUG=TRUE`. Visit the [PHP XDebug Documentation](https://xdebug.org/docs/all_settings#remote_connect_back) to understand what these options mean.
If you debug a PHP project in PHPStorm, you need to set server name using `PHP_IDE_CONFIG` to the same value as set in PHPStorm. Usual value is localhost, i.e. `PHP_IDE_CONFIG="serverName=localhost"`.

For Xdebug 2 (php <= 7.1) you should set:
| Parameter                                   | Description                                | Default         |
| ------------------------------------------- | ------------------------------------------ | --------------- |
| `PHP_MODULE_XDEBUG_PROFILER_PATH`           | Xdebug profiler path                       | `/logs/xdebug/` |
| `PHP_MODULE_XDEBUG_PROFILER_ENABLE`         | Enable Profiler                            | `0`             |
| `PHP_MODULE_XDEBUG_PROFILER_ENABLE_TRIGGER` | Enable Profiler Trigger                    | `0`             |
| `PHP_MODULE_XDEBUG_REMOTE_AUTOSTART`        | Enable Autostarting as opposed to GET/POST | `1`             |
| `PHP_MODULE_XDEBUG_REMOTE_CONNECT_BACK`     | Enbable Connection Back                    | `0`             |
| `PHP_MODULE_XDEBUG_REMOTE_ENABLE`           | Enable Remote Debugging                    | `1`             |
| `PHP_MODULE_XDEBUG_REMOTE_HANDLER`          | XDebug Remote Handler                      | `dbgp`          |
| `PHP_MODULE_XDEBUG_REMOTE_HOST`             | Set this to your IP Address                | `127.0.0.1`     |
| `PHP_MODULE_XDEBUG_REMOTE_PORT`             | XDebug Remote Port                         | `9090`          |

* * *

For Xdebug 3 (php >= 7.2) you should set:
| Parameter                                | Description                                                          | Default         |
| ---------------------------------------- | -------------------------------------------------------------------- | --------------- |
| `PHP_MODULE_XDEBUG_PROFILER_PATH`        | Xdebug profiler path                                                 | `/logs/xdebug/` |
| `PHP_MODULE_XDEBUG_MODE`                 | This setting controls which Xdebug features are enabled.             | `develop`       |
| `PHP_MODULE_XDEBUG_START_WITH_REQUEST`   | Enable Autostarting as opposed to GET/POST                           | `default`       |
| `PHP_MODULE_XDEBUG_DISCOVER_CLIENT_HOST` | Xdebug will try to connect to the client that made the HTTP request. | `1`             |
| `PHP_MODULE_XDEBUG_CLIENT_HOST`          | Set this to your IP Address                                          | `127.0.0.1`     |
| `PHP_MODULE_XDEBUG_CLIENT_PORT`          | XDebug Remote Port                                                   | `9003`          |

## Users and Groups

| Type  | Name       | ID     |
| ----- | ---------- | ------ |
| User  | `php`      | `9000` |
| Group | `php`      | `9000` |
| Group | `www-data` | `82`   |

### Networking

| Port   | Protocol | Description |
| ------ | -------- | ----------- |
| `9000` | tcp      | PHP-FPM     |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

* For community help, tips, and community discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
