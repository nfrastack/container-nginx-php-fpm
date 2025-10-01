# nfrastack/container-nginx-php-fpm

## About

This repository will build a [Nginx](https://www.nginx.org) w/[PHP-FPM](https://php.net) container image, suitable for serving PHP scripts, or utilizing as a base image for installing additional software.

* Tracking PHP 5.3-8.3
* Easily enable / disable extensions based on your use case
* Automatic Log rotation
* Composer Included
* XDebug capability
* Caching via APC, opcache
* Includes client libraries for [MariaDB](https://www.mariadb.org) and [Postgresql](https://www.postgresql.org)

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

`<image>:<branch>-<optional tag>`

Example:

`ghcr.io/nfrastack/container-nginx-php-fpm:latest` or

`ghcr.io/nfrastack/container-nginx-php-fpm:3.5-1.0`

* `branch` will be the repositories branch, typically matching with the version of nginx-php-fpm eg `3.5`
* `latest` will be the most recent commit
* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest

| PHP version | Alpine Base | Tag            | Debian Base | Tag                    |
| ----------- | ----------- | -------------- | ----------- | ---------------------- |
| latest      | edge        | `:alpine-edge` |             |                        |
| 8.4.x       | 3.22        | `:8.3-alpine`  | Bookworm    | `:8.4-debian-bookworm` |
| 8.3.x       | 3.20        | `:8.3-alpine`  | Bookworm    | `:8.3-debian-bookworm` |
| 8.2.x       | 3.20        | `:8.2-alpine`  | Bookworm    | `:8.2-debian-bookworm` |
| 8.1.x       | 3.19        | `:8.1-alpine`  | Bookworm    | `:8.1-debian-bookworm` |
| 8.0.x       | 3.16        | `:8.0-alpine`  | Bookworm    | `:8.0-debian-bookworm` |
| 7.4.x       | 3.15        | `:7.4-alpine`  | Bookworm    | `:7.4-debian-bookworm` |
| 7.3.x       | 3.12        | `:7.3-alpine`  | Bookworm    | `:7.3-debian-bookworm` |
| 7.2.x       | 3.9         | `:7.2-alpine`  |             |                        |
| 7.1.x       | 3.7         | `:7.1-alpine`  |             |                        |
| 7.0.x       | 3.5         | `:7.0-alpine`  |             |                        |
| 5.6.x       | 3.8         | `:5.6-alpine`  |             |                        |
| 5.5.x       | 3.4         | `:5.5-latest`  |             |                        |
| 5.3.x       | 3.4         | `:5.3-latest`  |             |                        |

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

The container starts up and reads from `/etc/nginx/nginx.conf` for some basic configuration and to listen on port 73 internally for Nginx Status responses. Configuration of websites are done in `/etc/services.available` with the filename pattern of `site.conf`. You must set an environment variable for `NGINX_SITE_ENABLED` if you have more than one configuration in there if you only want to enable one of the configurartions, otherwise it will enable all of them. Use `NGINX_SITE_ENABLED=null` to break a parent image declaration.

Use this as a starting point for your site configurations:
````nginx
  server {
      ### Don't Touch This
      listen {{NGINX_LISTEN_PORT}};
      server_name localhost;
      root {{NGINX_WEBROOT}};

      ### Populate your custom directives here
      index  index.php index.html index.htm;

      # Deny access to any files with a .php extension in the uploads directory
      location ~* /(?:uploads|files)/.*\.php$ {
          deny all;
      }

      location / {
          try_files \$uri \$uri/ /index.php?\$args;
      }

      ### Populate your custom directives here
      location ~ \.php(/|\$) {
          include /etc/nginx/snippets/php-fpm.conf;
          fastcgi_split_path_info ^(.+?\.php)(/.+)\$;
          fastcgi_param PATH_INFO \$fastcgi_path_info;
          fastcgi_index index.php;
          include fastcgi_params;
          fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
      }

      ### Don't edit past here
      include /etc/nginx/snippets/site_optimization.conf;
      include /etc/nginx/snippets/exploit_protection.conf;
    }
````

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

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Variable                       | Description                         | Default                                               |
| ------------------------------ | ----------------------------------- | ----------------------------------------------------- |
| `ENABLE_PHP_FPM`               | Enable PHP-FPM container mode       | `TRUE`                                                |
| `PHPFPM_CONTAINER_MODE`        | Container mode for PHP-FPM          | `nginx-php-fpm`                                       |
| `PHP_ENABLE_CREATE_SAMPLE_PHP` | Create a sample PHP page on startup | `TRUE`                                                |
| `PHP_HIDE_X_POWERED_BY`        | Hide X-Powered-By header            | `TRUE`                                                |
| `PHP_KITCHENSINK`              | Enable all PHP extensions           | `FALSE`                                               |
| `PHP_MEMORY_LIMIT`             | PHP memory limit                    | `128M`                                                |
| `PHP_POST_MAX_SIZE`            | Maximum POST size                   | `2G`                                                  |
| `PHP_TIMEOUT`                  | Script execution timeout            | `180`                                                 |
| `PHP_UPLOAD_MAX_SIZE`          | Maximum upload size                 | `2G`                                                  |
| `PHP_WEBROOT`                  | Webroot directory                   | `/www/html` (or `${NGINX_WEBROOT}`) |

#### PHP Environment
| Variable            | Description              | Default                                                        |
| ------------------- | ------------------------ | -------------------------------------------------------------- |
| `PHPFPM_ENV_TEMP`   | PHP-FPM temp directory   | `/tmp`                                                         |
| `PHPFPM_ENV_TMP`    | PHP-FPM tmp directory    | `/tmp`                                                         |
| `PHPFPM_ENV_TMPDIR` | PHP-FPM tmpdir           | `/tmp`                                                         |
| `PHPFPM_ENV_PATH`   | PHP-FPM PATH environment | `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` |

#### PHP Pools
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

| Type  | Name            | ID   |
| ----- | --------------- | ---- |
| User  | `nginx-php-fpm` | 8080 |
| Group | `nginx-php-fpm` | 8080 |

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

# github.com/tiredofit/docker-nginx-php-fpm

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-nginx-php-fpm?style=flat-square)](https://github.com/tiredofit/docker-nginx-php-fpm/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-nginx-php-fpm/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-nginx-php-fpm/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/nginx-php-fpm.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/nginx-php-fpm/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/nginx-php-fpm.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/nginx-php-fpm/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *


## About

This repository will build a [Nginx](https://www.nginx.org) w/[PHP-FPM](https://php.net) docker image, suitable for serving PHP scripts, or utilizing as a base image for installing additional software.

* Tracking PHP 5.3-8.3
* Easily enable / disable extensions based on your use case
* Automatic Log rotation
* Composer Included
* XDebug capability
* Caching via APC, opcache
* Includes client libraries for [MariaDB](https://www.mariadb.org) and [Postgresql](https://www.postgresql.org)

## Maintainer

- [Dave Conroy](http://github/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Enabling / Disabling Specific Extensions](#enabling--disabling-specific-extensions)
    - [Debug Options](#debug-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [PHP Extensions](#php-extensions)
  - [Maintenance Mode](#maintenance-mode)
- [Contributions](#contributions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)


## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/nfrastack/container-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)

## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`
### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/nginx-php-fpm)

```bash
docker pull docker.io/tiredofit/nginx-php-fpm:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-nginx-php-fpm/pkgs/container/docker-nginx-php-fpm)

```
docker pull ghcr.io/tiredofit/docker-nginx-php-fpm:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):


#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.



### Persistent Storage

The container starts up and reads from `/etc/nginx/nginx.conf` for some basic configuration and to listen on port 73 internally for Nginx Status responses. `/etc/nginx/conf.d` contains a sample configuration file that can be used to customize a nginx server block.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory   | Description                |
| ----------- | -------------------------- |
| `/www/html` | Root Directory             |
| `/www/logs` | Nginx and php-fpm logfiles |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)    | Nginx webserver                        |


#### Container Options

The container has an ability to work in 3 modes, `nginx-php-fpm` (default) is an All in One image with nginx and php-fpm working together, `nginx` will only utilize nginx however not the included php-fpm instance, allowing for connecting to multiple remote php-fpm backends, and finally `php-fpm` to operate PHP-FPM in standalone mode.


| Parameter                | Description                                                   | Default         |
| ------------------------ | ------------------------------------------------------------- | --------------- |
| `PHP_FPM_CONTAINER_MODE` | Mode of running container `nginx-php-fpm`, `nginx`, `php-fpm` | `nginx-php-fpm` |

When `PHP_FPM_CONTAINER_MODE` set to `nginx` the `PHP_FPM_LISTEN_PORT` environment variable is ignored and the `PHP_FPM_HOST` variable defined below changes. You can add multiple PHP-FPM hosts to the backend in this syntax
<host>:<port> seperated by commas e.g `php-fpm-container1:9000,php-fpm-container2:9000`

*You can also pass arguments to each server as defined in the [Nginx Upstream Documentation](https://nginx.org/en/docs/http/ngx_http_upstream_module.html)*

| Parameter                                    | Description                                                                                              | Default                                     |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `PHP_MODULE_APC_SHM_SIZE`                    | APC Cache Memory size - `0` to disable                                                                   | `128M`                                      |
| `PHP_MODULE_APC_TTL`                         | APC Time to live in seconds                                                                              | `7200`                                      |
| `PHP_FPM_HOST`                               | PHP-FPM Host, dependenent on PHP_FPM_LISTEN_TYPE, add multiple with commas                               | `127.0.0.1:9000` or `/var/run/php-fpm.sock` |
| `PHP_FPM_LISTEN_TYPE`                        | PHP-FPM listen type `UNIX` sockets or `TCP` sockets                                                      | `unix`                                      |
| `PHP_FPM_LISTEN_TCP_IP`                      | PHP-FPM Listening IP if `PHP_LISTEN_TYPE=TCP`                                                            | `0.0.0.0`                                   |
| `PHP_FPM_LISTEN_TCP_IP_ALLOWED`              | PHP-FPM allow only these hosts if `PHP_LISTEN_TYPE=TCP`                                                  | `127.0.0.1`                                 |
| `PHP_FPM_LISTEN_TCP_PORT`                    | PHP-FPM Listening Port - Ignored with above container options                                            | `9000`                                      |
| `PHP_FPM_LISTEN_UNIX_SOCKET`                 | PHP-FPM Listen Socket if `PHP_LISTEN_TYPE=UNIX`                                                          | `/var/run/php-fpm.sock`                     |
| `PHP_FPM_LISTEN_UNIX_SOCKET_USER`            | PHP-FPM Listen Socket user `PHP_LISTEN_TYPE=UNIX`                                                        | `${NGINX_USER}` or `${UNIT_USER}`           |
| `PHP_FPM_LISTEN_UNIX_SOCKET_GROUP`           | PHP-FPM Listen Socket group `PHP_LISTEN_TYPE=UNIX`                                                       | `${NGINX_GROUP}` or `${UNIT_GROUP}`         |
| `PHP_FPM_MAX_CHILDREN`                       | Maximum Children                                                                                         | `75`                                        |
| `PHP_FPM_MAX_REQUESTS`                       | How many requests before spawning new server                                                             | `500`                                       |
| `PHP_FPM_MAX_SPARE_SERVERS`                  | Maximum Spare Servers available                                                                          | `3`                                         |
| `PHP_FPM_MIN_SPARE_SERVERS`                  | Minium Spare Servers avaialble                                                                           | `1`                                         |
| `PHP_FPM_OUTPUT_BUFFER_SIZE`                 | Output buffer size in bytes                                                                              | `0`                                         |
| `PHP_FPM_POST_INIT_COMMAND`                  | If you wish to execute a command before php-fpm executes, enter it here and seperate multiples by comma. |                                             |
| `PHP_FPM_POST_INIT_SCRIPT`                   | If you wish to execute a script before php-fpm executes, enter it here and seperate multiples by comma.  |                                             |
| `PHP_FPM_PROCESS_MANAGER`                    | How to handle processes `static`, `ondemand`, `dynamic`                                                  | `dynamic`                                   |
| `PHP_FPM_START_SERVERS`                      | How many FPM servers to start initially                                                                  | `2`                                         |
| `PHP_FPM_USER`                               | User to run PHP-FPM master process as                                                                    | `${NGINX_USER}` or `${UNIT_USER}`           |
| `PHP_HIDE_X_POWERED_BY`                      | Hide X-Powered by response                                                                               | `TRUE`                                      |
| `PHP_LOG_ACCESS_FILE`                        | PHP Access Logfile Name                                                                                  | `access.log`                                |
| `PHP_LOG_ERROR_FILE`                         | Logfile name                                                                                             | `error.log`                                 |
| `PHP_LOG_LEVEL`                              | PHP Log Level `alert` `error` `warning` `notice` `debug`                                                 | `notice`                                    |
| `PHP_LOG_ACCESS_FORMAT`                      | Log format - `default` or `json`                                                                         | `default`                                   |
| `PHP_LOG_LIMIT`                              | Characters to log                                                                                        | `2048`                                      |
| `PHP_LOG_LOCATION`                           | Log Location for PHP Logs                                                                                | `/www/logs/php-fpm`                         |
| `PHP_MEMORY_LIMIT`                           | How much memory should PHP use                                                                           | `128M`                                      |
| `PHP_MODULE_OPCACHE_INTERNED_STRINGS_BUFFER` | OPCache interned strings buffer                                                                          | `8`                                         |
| `PHP_MODULE_OPCACHE_JIT_BUFFER_SIZE`         | JIT Buffer Size `0` to disable                                                                           | `50M`                                       |
| `PHP_MODULE_OPCACHE_JIT_MODE`                | JIT [CRTO](https://wiki.php.net/rfc/jit) Mode - > PHP 8.x                                                | `1255`                                      |
| `PHP_MODULE_OPCACHE_MAX_ACCELERATED_FILES`   | OPCache Max accelerated files                                                                            | `10000`                                     |
| `PHP_MODULE_OPCACHE_MEM_SIZE`                | OPCache Memory Size - Set `0` to disable or via other env vars                                           | `128`                                       |
| `PHP_MODULE_OPCACHE_REVALIDATE_FREQ`         | OPCache revalidate frequency in seconds                                                                  | `2`                                         |
| `PHP_MODULE_OPCACHE_MAX_WASTED_PERCENTAGE`   | Max wasted percentage cache                                                                              | `5`                                         |
| `PHP_MODULE_OPCACHE_VALIDATE_TIMESTAMPS`     | Validate timestamps `1` or `0`                                                                           | `1`                                         |
| `PHP_MODULE_OPCACHE_SAVE_COMMENTS`           | Opcache Save Comments `0` or `1`                                                                         | `1`                                         |
| `PHP_MODULE_OPCACHE_MAX_FILE_SIZE`           | Opcache maximum file size                                                                                | `0`                                         |
| `PHP_MODULE_OPCACHE_OPTIMIZATION_LEVEL`      | Opcache optimization level                                                                               | `0x7FFFBFF`                                 |
| `PHP_POST_MAX_SIZE`                          | Maximum Input Size for POST                                                                              | `2G`                                        |
| `PHP_TIMEOUT`                                | Maximum Script execution Time                                                                            | `180`                                       |
| `PHP_UPLOAD_MAX_SIZE`                        | Maximum Input Size for Uploads                                                                           | `2G`                                        |
| `PHP_WEBROOT`                                | Used with `CONTAINER_MODE=php-fpm`                                                                       | `/www/html`                                 |

#### Enabling / Disabling Specific Extensions

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

To enable all extensions in image use `PHP_KITCHENSINK=TRUE`. Head inside the image and see what extensions are available by typing `php-ext list all`

#### Debug Options
To enable XDebug set `PHP_MODULE_ENABLE_XDEBUG=TRUE`. Visit the [PHP XDebug Documentation](https://xdebug.org/docs/all_settings#remote_connect_back) to understand what these options mean.
If you debug a PHP project in PHPStorm, you need to set server name using `PHP_IDE_CONFIG` to the same value as set in PHPStorm. Usual value is localhost, i.e. `PHP_IDE_CONFIG="serverName=localhost"`.

For Xdebug 2 (php <= 7.1) you should set:
| Parameter                                   | Description                                | Default         |
| ------------------------------------------- | ------------------------------------------ | --------------- |
| `PHP_MODULE_XDEBUG_PROFILER_DIR`            | Where to store Profiler Logs               | `/logs/xdebug/` |
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
| Parameter                                | Description                                                          | Default             |
| ---------------------------------------- | -------------------------------------------------------------------- | ------------------- |
| `PHP_MODULE_XDEBUG_OUTPUT_DIR`           | Where to store Logs                                                  | `/www/logs/xdebug/` |
| `PHP_MODULE_XDEBUG_MODE`                 | This setting controls which Xdebug features are enabled.             | `develop`           |
| `PHP_MODULE_XDEBUG_START_WITH_REQUEST`   | Enable Autostarting as opposed to GET/POST                           | `default`           |
| `PHP_MODULE_XDEBUG_DISCOVER_CLIENT_HOST` | Xdebug will try to connect to the client that made the HTTP request. | `1`                 |
| `PHP_MODULE_XDEBUG_CLIENT_HOST`          | Set this to your IP Address                                          | `127.0.0.1`         |
| `PHP_MODULE_XDEBUG_CLIENT_PORT`          | XDebug Remote Port                                                   | `9003`              |

* * *

### Networking

The following ports are exposed.

| Port   | Description |
| ------ | ----------- |
| `9000` | PHP-FPM     |


## Maintenance
Inside the image are tools to perform modification on how the image runs.

### Shell Access
For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. nginx-php-fpm) bash
```
### PHP Extensions
If you want to enable or disable or list what PHP extensions are available, type `php-ext help`

### Maintenance Mode
If you wish to turn the web server into maintenance mode showing a single page screen outlining that the service is being worked on, you can also enter into the container and type `maintenance ARG`, where ARG is either `ON`,`OFF`, or `SLEEP (seconds)` which will temporarily place the site in maintenance mode and then restore it back to normal after time has passed.
## Contributions
Welcomed. Please fork the repository and submit a [pull request](../../pulls) for any bug fixes, features or additions you propose to be included in the image. If it does not impact my intended usage case, it will be merged into the tree, tagged as a release and credit to the contributor in the [CHANGELOG](CHANGELOG).

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- [Sponsor me](https://tiredofit.ca/sponsor) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- [Sponsor me](https://tiredofit.ca/sponsor) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- [Sponsor me](https://tiredofit.ca/sponsor) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* http://www.php.org
* https://xdebug.org
