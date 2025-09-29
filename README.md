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
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
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

| PHP version | Alpine Base | Tag            | Debian Base | Tag                    |
| ----------- | ----------- | -------------- | ----------- | ---------------------- |
| latest      | edge        | `:alpine-edge` |             |                        |
| 8.4.x       | 3.21        | `:8.3-alpine`  | Bookworm    | `:8.4-debian-bookworm` |
| 8.3.x       | 3.21        | `:8.3-alpine`  | Bookworm    | `:8.3-debian-bookworm` |
| 8.2.x       | 3.21        | `:8.2-alpine`  | Bookworm    | `:8.2-debian-bookworm` |
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

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

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

| Parameter                             | Description                                                                                              | Default                                     |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `PHP_APC_SHM_SIZE`                    | APC Cache Memory size - `0` to disable                                                                   | `128M`                                      |
| `PHP_APC_TTL`                         | APC Time to live in seconds                                                                              | `7200`                                      |
| `PHP_FPM_HOST`                        | PHP-FPM Host, dependenent on PHP_FPM_LISTEN_TYPE, add multiple with commas                               | `127.0.0.1:9000` or `/var/run/php-fpm.sock` |
| `PHP_FPM_LISTEN_TYPE`                 | PHP-FPM listen type `UNIX` sockets or `TCP` sockets                                                      | `unix`                                      |
| `PHP_FPM_LISTEN_TCP_IP`               | PHP-FPM Listening IP if `PHP_LISTEN_TYPE=TCP`                                                            | `0.0.0.0`                                   |
| `PHP_FPM_LISTEN_TCP_IP_ALLOWED`       | PHP-FPM allow only these hosts if `PHP_LISTEN_TYPE=TCP`                                                  | `127.0.0.1`                                 |
| `PHP_FPM_LISTEN_TCP_PORT`             | PHP-FPM Listening Port - Ignored with above container options                                            | `9000`                                      |
| `PHP_FPM_LISTEN_UNIX_SOCKET`          | PHP-FPM Listen Socket if `PHP_LISTEN_TYPE=UNIX`                                                          | `/var/run/php-fpm.sock`                     |
| `PHP_FPM_LISTEN_UNIX_SOCKET_USER`     | PHP-FPM Listen Socket user `PHP_LISTEN_TYPE=UNIX`                                                        | `${NGINX_USER}` or `${UNIT_USER}`           |
| `PHP_FPM_LISTEN_UNIX_SOCKET_GROUP`    | PHP-FPM Listen Socket group `PHP_LISTEN_TYPE=UNIX`                                                       | `${NGINX_GROUP}` or `${UNIT_GROUP}`         |
| `PHP_FPM_MAX_CHILDREN`                | Maximum Children                                                                                         | `75`                                        |
| `PHP_FPM_MAX_REQUESTS`                | How many requests before spawning new server                                                             | `500`                                       |
| `PHP_FPM_MAX_SPARE_SERVERS`           | Maximum Spare Servers available                                                                          | `3`                                         |
| `PHP_FPM_MIN_SPARE_SERVERS`           | Minium Spare Servers avaialble                                                                           | `1`                                         |
| `PHP_FPM_OUTPUT_BUFFER_SIZE`          | Output buffer size in bytes                                                                              | `0`                                         |
| `PHP_FPM_POST_INIT_COMMAND`           | If you wish to execute a command before php-fpm executes, enter it here and seperate multiples by comma. |                                             |
| `PHP_FPM_POST_INIT_SCRIPT`            | If you wish to execute a script before php-fpm executes, enter it here and seperate multiples by comma.  |                                             |
| `PHP_FPM_PROCESS_MANAGER`             | How to handle processes `static`, `ondemand`, `dynamic`                                                  | `dynamic`                                   |
| `PHP_FPM_START_SERVERS`               | How many FPM servers to start initially                                                                  | `2`                                         |
| `PHP_FPM_USER`                        | User to run PHP-FPM master process as                                                                    | `${NGINX_USER}` or `${UNIT_USER}`           |
| `PHP_HIDE_X_POWERED_BY`               | Hide X-Powered by response                                                                               | `TRUE`                                      |
| `PHP_LOG_ACCESS_FILE`                 | PHP Access Logfile Name                                                                                  | `access.log`                                |
| `PHP_LOG_ERROR_FILE`                  | Logfile name                                                                                             | `error.log`                                 |
| `PHP_LOG_LEVEL`                       | PHP Log Level `alert` `error` `warning` `notice` `debug`                                                 | `notice`                                    |
| `PHP_LOG_ACCESS_FORMAT`               | Log format - `default` or `json`                                                                         | `default`                                   |
| `PHP_LOG_LIMIT`                       | Characters to log                                                                                        | `2048`                                      |
| `PHP_LOG_LOCATION`                    | Log Location for PHP Logs                                                                                | `/www/logs/php-fpm`                         |
| `PHP_MEMORY_LIMIT`                    | How much memory should PHP use                                                                           | `128M`                                      |
| `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | OPCache interned strings buffer                                                                          | `8`                                         |
| `PHP_OPCACHE_JIT_BUFFER_SIZE`         | JIT Buffer Size `0` to disable                                                                           | `50M`                                       |
| `PHP_OPCACHE_JIT_MODE`                | JIT [CRTO](https://wiki.php.net/rfc/jit) Mode - > PHP 8.x                                                | `1255`                                      |
| `PHP_OPCACHE_MAX_ACCELERATED_FILES`   | OPCache Max accelerated files                                                                            | `10000`                                     |
| `PHP_OPCACHE_MEM_SIZE`                | OPCache Memory Size - Set `0` to disable or via other env vars                                           | `128`                                       |
| `PHP_OPCACHE_REVALIDATE_FREQ`         | OPCache revalidate frequency in seconds                                                                  | `2`                                         |
| `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`   | Max wasted percentage cache                                                                              | `5`                                         |
| `PHP_OPCACHE_VALIDATE_TIMESTAMPS`     | Validate timestamps `1` or `0`                                                                           | `1`                                         |
| `PHP_OPCACHE_SAVE_COMMENTS`           | Opcache Save Comments `0` or `1`                                                                         | `1`                                         |
| `PHP_OPCACHE_MAX_FILE_SIZE`           | Opcache maximum file size                                                                                | `0`                                         |
| `PHP_OPCACHE_OPTIMIZATION_LEVEL`      | Opcache optimization level                                                                               | `0x7FFFBFF`                                 |
| `PHP_POST_MAX_SIZE`                   | Maximum Input Size for POST                                                                              | `2G`                                        |
| `PHP_TIMEOUT`                         | Maximum Script execution Time                                                                            | `180`                                       |
| `PHP_UPLOAD_MAX_SIZE`                 | Maximum Input Size for Uploads                                                                           | `2G`                                        |
| `PHP_WEBROOT`                         | Used with `CONTAINER_MODE=php-fpm`                                                                       | `/www/html`                                 |
| `PHP_DISPLAY_ERRORS`                  | Show PHP errors in the output                                                                            | `FALSE`                                     |

#### Enabling / Disabling Specific Extensions

Enable extensions by using the PHP extension name ie redis as `PHP_ENABLE_REDIS=TRUE`. Core extensions are enabled by default are:

| Parameter              | Default |
| ---------------------- | ------- |
| `PHP_ENABLE_APCU`      | `TRUE`  |
| `PHP_ENABLE_BCMATH`    | `TRUE`  |
| `PHP_ENABLE_BZ2`       | `TRUE`  |
| `PHP_ENABLE_CTYPE`     | `TRUE`  |
| `PHP_ENABLE_CURL`      | `TRUE`  |
| `PHP_ENABLE_DOM`       | `TRUE`  |
| `PHP_ENABLE_EXIF`      | `TRUE`  |
| `PHP_ENABLE_FILEINFO`  | `TRUE`  |
| `PHP_ENABLE_GD`        | `TRUE`  |
| `PHP_ENABLE_ICONV`     | `TRUE`  |
| `PHP_ENABLE_IMAP`      | `TRUE`  |
| `PHP_ENABLE_INTL`      | `TRUE`  |
| `PHP_ENABLE_JSON`      | `TRUE`  |
| `PHP_ENABLE_MBSTRING`  | `TRUE`  |
| `PHP_ENABLE_MYSQLI`    | `TRUE`  |
| `PHP_ENABLE_MYSQLND`   | `TRUE`  |
| `PHP_ENABLE_OPCACHE`   | `TRUE`  |
| `PHP_ENABLE_OPENSSL`   | `TRUE`  |
| `PHP_ENABLE_PDO`       | `TRUE`  |
| `PHP_ENABLE_PDO_MYSQL` | `TRUE`  |
| `PHP_ENABLE_PGSQL`     | `TRUE`  |
| `PHP_ENABLE_PHAR`      | `TRUE`  |
| `PHP_ENABLE_SESSION`   | `TRUE`  |
| `PHP_ENABLE_SIMPLEXML` | `TRUE`  |
| `PHP_ENABLE_TOKENIZER` | `TRUE`  |
| `PHP_ENABLE_XML`       | `TRUE`  |
| `PHP_ENABLE_XMLREADER` | `TRUE`  |
| `PHP_ENABLE_XMLWRITER` | `TRUE`  |

To enable all extensions in image use `PHP_KITCHENSINK=TRUE`. Head inside the image and see what extensions are available by typing `php-ext list all`

#### Debug Options
To enable XDebug set `PHP_ENABLE_XDEBUG=TRUE`. Visit the [PHP XDebug Documentation](https://xdebug.org/docs/all_settings#remote_connect_back) to understand what these options mean.
If you debug a PHP project in PHPStorm, you need to set server name using `PHP_IDE_CONFIG` to the same value as set in PHPStorm. Usual value is localhost, i.e. `PHP_IDE_CONFIG="serverName=localhost"`.

For Xdebug 2 (php <= 7.1) you should set:
| Parameter                            | Description                                | Default             |
| ------------------------------------ | ------------------------------------------ | ------------------- |
| `PHP_XDEBUG_PROFILER_DIR`            | Where to store Profiler Logs               | `/www/logs/xdebug/` |
| `PHP_XDEBUG_PROFILER_ENABLE`         | Enable Profiler                            | `0`                 |
| `PHP_XDEBUG_PROFILER_ENABLE_TRIGGER` | Enable Profiler Trigger                    | `0`                 |
| `PHP_XDEBUG_REMOTE_AUTOSTART`        | Enable Autostarting as opposed to GET/POST | `1`                 |
| `PHP_XDEBUG_REMOTE_CONNECT_BACK`     | Enbable Connection Back                    | `0`                 |
| `PHP_XDEBUG_REMOTE_ENABLE`           | Enable Remote Debugging                    | `1`                 |
| `PHP_XDEBUG_REMOTE_HANDLER`          | XDebug Remote Handler                      | `dbgp`              |
| `PHP_XDEBUG_REMOTE_HOST`             | Set this to your IP Address                | `127.0.0.1`         |
| `PHP_XDEBUG_REMOTE_PORT`             | XDebug Remote Port                         | `9090`              |

* * *

For Xdebug 3 (php >= 7.2) you should set:
| Parameter                         | Description                                                          | Default             |
| --------------------------------- | -------------------------------------------------------------------- | ------------------- |
| `PHP_XDEBUG_OUTPUT_DIR`           | Where to store Logs                                                  | `/www/logs/xdebug/` |
| `PHP_XDEBUG_MODE`                 | This setting controls which Xdebug features are enabled.             | `develop`           |
| `PHP_XDEBUG_START_WITH_REQUEST`   | Enable Autostarting as opposed to GET/POST                           | `default`           |
| `PHP_XDEBUG_DISCOVER_CLIENT_HOST` | Xdebug will try to connect to the client that made the HTTP request. | `1`                 |
| `PHP_XDEBUG_CLIENT_HOST`          | Set this to your IP Address                                          | `127.0.0.1`         |
| `PHP_XDEBUG_CLIENT_PORT`          | XDebug Remote Port                                                   | `9003`              |

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
