## 8.0.0 2026-02-23 <code at nfastack dot com>

   ### Added
      - Supporting PHP 8.5 and Alpine 3.23
      - Multiple Pool Support
      - Many differnet customization options
      - Dynamic configuration of PHP location block
      - Uses nfrastack/container-nginx:8.x.x as base image


## 7.7.20 2025-08-16 <dave at tiredofit dot ca>

   ### Changed
      - Change php8.1-alpine to use alpine 3.18 base with prebuilt images


## 7.7.19 2025-04-27 <dave at tiredofit dot ca>

   ### Added
      - Pin to tiredofit/nginx:6.5.18


## 7.7.18 2025-04-25 <dave at tiredofit dot ca>

   ### Added
      - Pin to tiredofit/nginx:6.5.17


## 7.7.17 2024-12-19 <dave at tiredofit dot ca>

   ### Reverted
      - Remove php84-spell component to support building under Alpine


## 7.7.16 2024-12-12 <dave at tiredofit dot ca>

   ### Added
      - Pin to tiredofit/nginx:6.5.10


## 7.7.15 2024-12-09 <dave at tiredofit dot ca>

   ### Added
      - Alpine pin to tiredofit/nginx:6.5.8


## 7.7.14 2024-12-07 <dave at tiredofit dot ca>

   ### Added
      - Add PHP 8.4 Support

   ### Changed
      - Switch PHP 8.3 and PHP 8.2 to use Alpine 3.21 as base


## 7.7.13 2024-10-22 <dave at tiredofit dot ca>

   ### Added
      - Pin to tiredofit/nginx:6.5.4


## 7.7.12 2024-10-04 <dave at tiredofit dot ca>

   ### Added
      - Pin to tiredofit/alpine:6.5.3


## 7.7.11 2024-09-26 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup php-ext script
      - Pin to tiredofit/nginx:6.5.2


## 7.7.10 2024-09-25 <dave at tiredofit dot ca>

   ### Added
      - Add php-ext disable reset statement to refresh environments


## 7.7.9 2024-09-25 <dave at tiredofit dot ca>

   ### Changed
      - Remove stray cat command in Dockerfile

## 7.7.8 2024-05-01 <dave at tiredofit dot ca>

   ### Changed
      - Change sury.org GPG key for Debian installations


## 7.7.7 2024-04-16 <dave at tiredofit dot ca>

   ### Added
      - Add php83 extensions: ds,event,grpc,imagick,opentelemetry,pcov,rdkafka,smblient,ssh2
      - Add php82 extensions: decimal,ds,event,grpc,mailparse,mcrypt,opentelemetry,pcov,rdkafka,smbclient,ssh2,timezonedb,vips,xlswriter
      - Add php81 extensions: decimal,ds,luasandbox,mcrypt,opentelemetry,pcov,smbclient


## 7.7.6 2024-02-16 <dave at tiredofit dot ca>

   ### Changed
      - Remove Suhosin from hp5.6 variant


## 7.7.5 2024-01-26 <dave at tiredofit dot ca>

   ### Reverted
      - Remove lz4 extension from Debian variant


## 7.7.4 2023-12-08 <dave at tiredofit dot ca>

   ### Changed
      - Add alpine:3.19


## 7.7.3 2023-12-05 <dave at tiredofit dot ca>

   ### Changed
      - Change build for Alpine PHP 8.3 to not include 4 PECL extensions


## 7.7.2 2023-11-28 <dave at tiredofit dot ca>

   ### Reverted
      - Drop php-lua extension


## 7.7.1 2023-11-28 <dave at tiredofit dot ca>

   ### Changed
      - Remove `BOTH` Option for PHP_FPM_LISTEN_TYPE


## 7.7.0 2023-11-25 <dave at tiredofit dot ca>

   ### Added
      - Allow listening on Unix Socket or TCP Socket (default Unix Socket)
      - Add host/ip restrictions for TCP listening
      - Add PHP_FPM_USER and PHP_FPM_GROUP variables to create isolation from upstream image (default NGINX_ or UNIT_ USER|GROUP)


## 7.6.16 2023-11-22 <dave at tiredofit dot ca>

   ### Added
      - Introduce PHP 8.3 support


## 7.6.15 2023-09-13 <dave at tiredofit dot ca>

   ### Changed
      - Fix PHP_TIMEOUT not affecting php-cli operations causing unnecessary Signal 15s in some cases


## 7.6.14 2023-09-05 <fermion2020@github>

   ### Changed
      - Fixed not working LLNG handler authentification
      - Fixed creating a default index page

## 7.6.13 2023-07-28 <dave at tiredofit dot ca>

   ### Reverted
      - Remove php-decimal extension from Debian variant


## 7.6.12 2023-07-28 <dave at tiredofit dot ca>

   ### Added
      - Add support for Debian Bookworm

   ### Changed
      - Cleanup some PHP directories that shouldn't exist on Debian variants


## 7.6.11 2023-07-25 <dave at tiredofit dot ca>

   ### Changed
      - Change environment variable case


## 7.6.10 2023-07-06 <dave at tiredofit dot ca>

   ### Added
      - Source defaults from upstream nginx container to avoid having to use NGINX_ENABLE_APPLICATION_CONFIGURATION=TRUE variable


## 7.6.9 2023-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Fix case introduced with 7.6.8 where authentication takes over default settings


## 7.6.8 2023-06-20 <dave at tiredofit dot ca>

   ### Changed
      - Restructure authentication routines when no NGINX_SITE_ENABLED being used to properly allow NGINX_AUTHENTICATION_TYPE=LLNG to be used.


## 7.6.6 2023-06-19 <dave at tiredofit dot ca>

   ### Changed
      - Stop building gnupg extension for <PHP 8.1


## 7.6.5 2023-05-30 <dave at tiredofit dot ca>

   ### Changed
      - Drop requirement of gnu-libiconv for < PHP 8.0 on alpine


## 7.6.4 2023-05-12 <dave at tiredofit dot ca>

   ### Reverted
      - Remove php82-pecl-phalcon for Alpine 3.18


## 7.6.3 2023-05-12 <dave at tiredofit dot ca>

   ### Changed
      - Strip pecl packages that no longer exist in Arch 3.18 repository for PHP 8.2


## 7.6.2 2023-05-10 <dave at tiredofit dot ca>

   ### Changed
      - Change PHP 8.2 to build with Alpine 3.18 Base
      - Change PHP 8.1 to build with Alpine 3.18 Base
      - Drop PHP 3.17 base variant


## 7.6.1 2023-04-04 <dave at tiredofit dot ca>

   ### Reverted
      - Remove spx extension from PHP 8.2 alpine


## 7.6.0 2023-03-24 <dave at tiredofit dot ca>

   ### Added
      - Added dozens of extra modules for Alpine PHP 8.0, 8.1, 8.2 variants


## 7.5.6 2023-03-23 <dave at tiredofit dot ca>

   ### Changed
      - Load MSGPACK when loading Redis module


## 7.5.5 2023-03-23 <dave at tiredofit dot ca>

   ### Added
      - Add more OPCache options and fix broken options


## 7.5.4 2023-03-23 <dave at tiredofit dot ca>

   ### Added
      - Add testing repository for PHP 8.2-alpine


## 7.5.3 2023-03-23 <dave at tiredofit dot ca>

   ### Added
      - Introduce PHP_HIDE_X_POWERED_BY variable


## 7.5.2 2023-03-20 <dave at tiredofit dot ca>

   ### Added
      - Add gnu-libconv package


## 7.5.1 2023-03-16 <dave at tiredofit dot ca>

   ### Changed
      - Change log_errors_max_len to 0 in php.ini from 1024

   ### Reverted
      - Strip php_admin_value[log_errors_max_len] from fpm config


## 7.5.0 2023-03-15 <dave at tiredofit dot ca>

   ### Changed
      - Quiet down output when loading defaults (xxx is already loaded! warnings)
      - Rework initialization
      - Fix a weird opcache issue


## 7.4.2 2023-02-21 <radarsymphony@github>

   ### Changed
      - Fix for LLNG_AUTHENTICATION_TYPE not reading variables properly


## 7.4.1 2023-01-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix for 7.4.0


## 7.4.0 2023-01-15 <dave at tiredofit dot ca>

   ### Added
      - Add JIT Compilation support by means of PHP_OPCACHE_JIT_MODE and PHP_OPCACHE_BUFFER_SIZE variables (8.x only)

   ### Changed
      - Minor formatting fixes


## 7.3.4 2023-01-11 <dave at tiredofit dot ca>

   ### Changed
      - Convert alias to function in php-ext for non interactive sessions


## 7.3.3 2023-01-10 <dave at tiredofit dot ca>

   ### Changed
      - Fix for `php-ext` not reading modules with underscores properly (credit timoschwarzer@github)


## 7.3.2 2022-12-14 <dave at tiredofit dot ca>

   ### Changed
      - Fix PHP_BASE issue with modules not loading introduced with 7.3.0


## 7.3.1 2022-12-13 <dave at tiredofit dot ca>

   ### Changed
      - Patchup for 8.2.x on Alpine systems


## 7.3.0 2022-12-11 <dave at tiredofit dot ca>

   ### Added
      - Introduce PHP 8.2 Support

   ### Changed
      - Rework Dockerfiles


## 7.2.1 2022-11-23 <dave at tiredofit dot ca>

   ### Changed
      - Switch PHP 8.1 base to Alpine 3.17


## 7.2.0 2022-10-13 <dave at tiredofit dot ca>

   ### Added
      - Introduce customizable Opcache and APC environment variables


## 7.1.1 2022-10-05 <dave at tiredofit dot ca>

   ### Changed
      - Remvoe /var/log entries in Dockerfile build


## 7.1.0 2022-10-01 <dave at tiredofit dot ca>

   ### Added
      - Convert to using update_template functions when configuring

   ### Changed
      - Fix an error where sample php file wasn't being created properly


## 7.0.11 2022-09-16 <dave at tiredofit dot ca>

   ### Changed
      - Change the way PHP_DISPLAY_ERRORS works in code - True / False actually works


## 7.0.10 2022-08-17 <dave at tiredofit dot ca>

   ### Changed
      - Switch to using exec to have process take over pid


## 7.0.9 2022-08-08 <dave at tiredofit dot ca>

   ### Changed
      - Additional fixes to 7.0.8


## 7.0.8 2022-08-08 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Kitchen Sink mode showing pathnames on print_notice command
      - Stop using log_length parameter for < PHP-FPM 7.3


## 7.0.7 2022-07-18 <dave at tiredofit dot ca>

   ### Changed
      - Fix for keepalives in upstream


## 7.0.6 2022-07-09 <dave at tiredofit dot ca>

   ### Changed
      - Escape document_root for FastCGI default scripts


## 7.0.5 2022-07-06 <dave at tiredofit dot ca>

   ### Changed
      - Fix for blank configuration not passing proper fastcgi_params
      - Stop throwing an error for openssl if it doesn't exist in the slightest


## 7.0.4 2022-07-06 <dave at tiredofit dot ca>

   ### Changed
      - Debian: Switch to PHP_BASE versioned msgpack module


## 7.0.3 2022-07-05 <dave at tiredofit dot ca>

   ### Changed
      - Add ARG for easier build argument shifting with CI and command line


## 7.0.2 2022-07-04 <dave at tiredofit dot ca>

   ### Changed
      - Bugfix when there is no default.conf file available


## 7.0.1 2022-07-03 <dave at tiredofit dot ca>

   ### Added
      - Add PHP_FPM_OUTPUT_BUFFER_SIZE environment variable


## 7.0.0 2022-06-23 <dave at tiredofit dot ca>

   ### Added
      - Rewrote entire image and split into functions to be reused in descendent images
      - Rework to support tiredofit/nginx:6.0.0 and its changes

   ### Changed
      - Rename CONTAINER_MODE variable
      - Quiet down output on extension loading/unloading


## 6.4.10 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine: Switch PHP 8 and 8.1 to Alpine 3.16 base


## 6.4.9 2022-04-12 <unlink@github>

   ### Changed
      - Add support for debugging with PHPStorm

## 6.4.8 2022-04-11 <unlink@github>

   ### Changed
      - Fix for open brace in if statement
      - Revamp Xdebug options for PHP 7.2 and higher


## 6.4.7 2022-04-06 <dave at tiredofit dot ca>

   ### Changed
      - Adjust defaults to use proper if statements as opposed to shortcuts


## 6.4.6 2022-03-18 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Debian images not including redis extension


## 6.4.5 2022-03-11 <dave at tiredofit dot ca>

   ### Changed
      - Sanity checks to be able to survive "warm" restarts


## 6.4.4 2022-03-08 <dave at tiredofit dot ca>

   ### Added
      - Remove php74-embed


## 6.4.3 2022-03-04 <dave at tiredofit dot ca>

   ### Changed
      - Change the way that upstream blocks are being added - stop relying on default.conf, instead put them in nginx.conf


## 6.4.2 2022-03-03 <dave at tiredofit dot ca>

   ### Changed
      - Patchup for 6.4.1


## 6.4.1 2022-03-02 <dave at tiredofit dot ca>

   ### Added
      - Add PHP_FPM_POST_INIT_SCRIPT variable to execute scripts before php-fpm process starts
      - Add PHP_FPM_POST_INIT_COMMAND variable to execute command before php-fpm-process starts


## 6.4.0 2022-02-23 <dave at tiredofit dot ca>

   ### Added
      - Add multiple PHP upstream hosts by default
      - Update LLNG Authentication to use Upstream Hosts

   ### Changed
      - Code Cleanup, refactoring


## 6.3.7 2022-02-22 <dave at tiredofit dot ca>

   ### Added
      - Patchup Alpine Mono Dockerfile to properly build PHP 8.1 variants


## 6.3.6 2022-02-09 <dave at tiredofit dot ca>

   ### Changed
      - Fixes for builds showing up as PHP 8.1 instead of what they should be
      - Base image updates

   ### Reverted


## 6.3.5 2021-12-28 <dave at tiredofit dot ca>

   ### Changed
      - Fixup for LibTidy throwing errors


## 6.3.4 2021-12-27 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Zabbix Opcache monitoring


## 6.3.3 2021-12-16 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup some of the autodiscover routines should Nginx or PHP-FPM be running in 'standalone' mode


## 6.3.2 2021-12-14 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Docker Mono repo for PHP < 7.3 failing


## 6.3.1 2021-12-10 <dave at tiredofit dot ca>

   ### Changed
      - Fix for 6.3.0 Zabbix Templates and switch to User Parameters


## 6.3.0 2021-12-07 <dave at tiredofit dot ca>

   ### Changed
      - Rework Zabbix Monitoring scripts and templates


## 6.2.15 2021-12-01 <dave at tiredofit dot ca>

   ### Changed
      - Stop OpenSSL warning in PHP 8.1


## 6.2.14 2021-11-24 <dave at tiredofit dot ca>

   ### Added
      - Change PHP 7.4 and 8.0 to use Alpine 3.15 as base


## 6.2.13 2021-11-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Zabbix PHP-FPM Metrics not functioning when AUTHENTICATION_TYPE=LLNG


## 6.2.12 2021-11-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix for XDebug Log Path


## 6.2.11 2021-11-16 <dave at tiredofit dot ca>

   ### Changed
      - Adjustment to Log Level integer


## 6.2.10 2021-11-10 <dave at tiredofit dot ca>

   ### Changed
      - Change the way that access logs are being configured on startup for those who don't stop and destroy a container completely


## 6.2.9 2021-10-28 <dave at tiredofit dot ca>

   ### Changed
      - Debian: Fix for pulling in MariaDB repository


## 6.2.8 2021-10-28 <dave at tiredofit dot ca>

   ### Changed
      - Fix with pulling in MariaDB Repository


## 6.2.7 2021-10-20 <dave at tiredofit dot ca>

   ### Added
      - Add mariadb-connector-c to fix SHA2 problems with connecting to MariaDB 8.0 systems


## 6.2.6 2021-10-19 <dave at tiredofit dot ca>

   ### Added
      - Add PHP_LOG_LIMIT environment variable to ensure single line log levels in access/error.log


## 6.2.5 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Redo how logrotate files were created


## 6.2.4 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Opcache key removal for Zabbix monitoring


## 6.2.3 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Fix for monitoring PHP-FPM


## 6.2.2 2021-09-01 <dave at tiredofit dot ca>

   ### Changed
      - Fix for logformats


## 6.2.1 2021-09-01 <dave at tiredofit dot ca>

   ### Changed
      - Fix for msmtp not working due to a change in upstream base images


## 6.2.0 2021-08-29 <dave at tiredofit dot ca>

   ### Added
      - Added Access Log support with standard/default string output or json output
      - Fluent-Bit Log Parsing support


## 6.1.21 2021-08-19 <dave at tiredofit dot ca>

   ### Changed
      - Change the way dependent modules are loaded in defaults


## 6.1.20 2021-08-18 <dave at tiredofit dot ca>

   ### Changed
      - Change to PECL http package


## 6.1.19 2021-08-18 <dave at tiredofit dot ca>

   ### Changed
      - Change to PHP Memcached plugin for debian


## 6.1.18 2021-08-05 <dave at tiredofit dot ca>

   ### Added
      - Add another value for socket timeout
      - Cleanup some opcache console annoyances


## 6.1.17 2021-07-12 <dave at tiredofit dot ca>

   ### Changed
      - Move around some LLNG Authentication blocks


## 6.1.16 2021-07-05 <dave at tiredofit dot ca>

   ### Added
      - Support upstream image changes

## 6.1.15 2021-06-08 <dave at tiredofit dot ca>

   ### Added
      - Add Hook to load IGBINARY when PHP_ENABLE_MEMCACHED=TRUE


## 6.1.14 2021-06-04 <dave at tiredofit dot ca>

   ### Added
      - Enable APC Caching for CLI


## 6.1.13 2021-05-29 <dave at tiredofit dot ca>

   ### Changed
      - Final permissions fix for MSMTP


## 6.1.12 2021-05-25 <dave at tiredofit dot ca>

   ### Changed
      - Additional checks for msmtp usage - If ENABLE_SMTP=FALSE then don't execute permissions settings


## 6.1.11 2021-05-25 <dave at tiredofit dot ca>

   ### Changed
      - Change the way that LLNG authentication gets loaded


## 6.1.10 2021-05-24 <dave at tiredofit dot ca>

   ### Changed
      - Fix for 6.1.9 permissions


## 6.1.9 2021-05-24 <dave at tiredofit dot ca>

   ### Changed
      - Update msmtprc file with nginx user/group permissions to allow php-fpm to send
      - Shuffle XDebug environment variables and configuraiton around


## 6.1.8 2021-05-19 <dave at tiredofit dot ca>

   ### Added
      - Add gpgme package (Alpine)

   ### Changed
      - Fix for php-ext enable script to stop loading json if PHP > 8
      - GPG extension loading fix


## 6.1.7 2021-05-05 <dave at tiredofit dot ca>

   ### Changed
      - Force OPENSSL extension to be activated by default to fix composer errors


## 6.1.6 2021-05-04 <dave at tiredofit dot ca>

   ### Changed
      - Fix for opcache being loaded twice in some scenarios


## 6.1.5 2021-05-03 <dave at tiredofit dot ca>

   ### Changed
      - Fix for enabling json warning under php8


## 6.1.4 2021-05-03 <dave at tiredofit dot ca>

   ### Changed
      - Fix for JSON for <php7


## 6.1.3 2021-05-03 <dave at tiredofit dot ca>

   ### Changed
      - Add PHP_ENABLE_SESSION=TRUE to defaults
      - Set PHP_ENABLE_IGBINARY=TRUE when PHP_ENABLE_REDIS=TRUE


## 6.1.2 2021-05-01 <dave at tiredofit dot ca>

   ### Changed
      - Fixes to php extension script specifically under Alpine


## 6.1.1 2021-05-01 <dave at tiredofit dot ca>

   ### Changed
      - Fix for determining PHP version on runtime


## 6.1.0 2021-04-22 <dave at tiredofit dot ca>

   ### Changed
      - Unified Script for Alpine and Debian
      - Merged all changes up to 6.xx into Alpine build

## 6.0.1 2021-04-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix PHP Extension script
      - Opcache seems to want to load twice for some reason, dirty hack enabled
      - Composer wasn't installing properly


## 6.0.0 2021-04-16 <dave at tiredofit dot ca>

   ### Added
      - Merged Debian branches into one - Use Build Argument of PHP_BASE to build `7.3` `7.4` or `8.0`
      - Composer 2.x
      - Massively revamped module loading. Try `php-env` from the command line to enable, disable, see modules available per version
      - Building for Stretch and Buster, ready for Bullseye
      - Building and amd64, arm7, arm64

## 5.6.0 2020-10-26 <dave at tiredofit dot ca>

   ### Added
      - Add composer version declaration (pinning to 1.10.16)


## 5.5.3 2020-08-29 <dave at tiredofit dot ca>

   ### Added
      - Add ENABLE_PHP_FPM environment variable


## 5.5.2 2020-08-10 <dave at tiredofit dot ca>

   ### Changed
      - Fix to regex for LLNG Authentication


## 5.5.1 2020-07-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix logrotate for PHP-FPM


## 5.5.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/debian 5.0.0 base image


## 5.4.1 2020-06-05 <dave at tiredofit dot ca>

   ### Changed
      - Move /etc/s6/services to /etc/services.d


## 5.4.0 2020-05-13 <dave at tiredofit dot ca>

   ### Added
      - PHP 7.3 - Debian Buster Variant


## 5.3.7 2020-04-21 <dave at tiredofit dot ca>

   ### Changed
      - Remove extra logrotate.d file added by packages


## 5.3.6 2020-04-21 <dave at tiredofit dot ca>

   ### Changed
      - Fix for PHP Plugins not enabling correctly


## 5.3.5 2020-04-18 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 4.5.1 base image


## 5.3.4 2020-03-16 <dave at tiredofit dot ca>

   ### Changed
      - Change msmtp configuration


## 5.3.3 2020-03-04 <dave at tiredofit dot ca>

   ### Added
      - Update image to support new tiredofit/alpine:4.4.0 base image

## 5.3.1 2020-01-20 <dave at tiredofit dot ca>

   ### Changed
      - Change the way PHP XDebug is being called


## 5.3.0 2020-01-04 <dave at tiredofit dot ca>

   ### Added
      - Add new `CONTAINER_MODE` environment variable to allow standalone operation for load balancing
      - Add new `PHP_WEBROOT` environment variable when `CONTAINER_MODE` set to `php-fpm`


## 5.2.2 2020-01-03 <dave at tiredofit dot ca>

   ### Added
      - ADD PHP_POST_MAX_SIZE environment variable

   ### Changed
      - Cleanup with LLNG Authentication
      - Properly assign PHP_UPLOAD_MAX_SIZE and PHP_POST_MAX_SIZE variables


## 5.2.0 2019-12-31 <dave at tiredofit dot ca>

   ### Added
      - Move defaults to /assets/functions files

   ### Changed
      - Change warnings to notices


## 5.1.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 5.0.4 2019-12-19 <dave at tiredofit dot ca>

   ### Changed
      - Change to LLNG Authentication Auto Configuration Routines


## 5.0.3 2019-12-18 <dave at tiredofit dot ca>

   ### Changed
      - Fixed error with display errors configuration

## 5.0.2 2019-12-18 <dave at tiredofit dot ca>

   ### Changed
      - Change to support dynamic webserver user/group


## 5.0.1 2019-12-04 <dave at tiredofit dot ca>

   ### Changed
      - Make MySQL Default Enabled


## 5.0.0 2019-12-04 <dave at tiredofit dot ca>

   ### Added
      - Reworked entire image
      - Added many new variables
      - Basing off of tiredofit/nginx
      - Code Cleanup


## 4.4.2 2019-11-18 <dave at tiredofit dot ca>

   ### Changed
      - Update Nginx proxy temp location


## 4.4.1 2019-07-08 <dave at tiredofit dot ca>

* Add tmp folder during startup to avoid bootloop

## 4.4 2019-06-19 <dave at tiredofit dot ca>

* PHP 7.3
* Alpine 3.10

## 4.3 2019-03-03 <dave at tiredofit dot ca>

* Move Alpine base to 3.9

## 4.2 2018-12-17 <dave at tiredofit dot ca>

* Add Nginx tmp cache directory

## 4.1 2018-11-28 <dave at tiredofit dot ca>

* Fix Timezone setting for php.ini

## 4.0.1 2018-11-19 <dave at tiredofit dot ca>

* Update further LLNG

## 4.0 2018-04-28 <dave at tiredofit dot ca>

* Ability to protect service via basic authentication or using LemonLDAP:NG Handlers


## 3.7 2018-04-22 <dave at tiredofit dot ca>

* Tweak SMTP to always route through msmtp based on new Base Image Changes

## 3.6 2018-04-02 <dave at tiredofit dot ca>

* Added MAINTENANCE environment variable to move system to maintenance mode. Also maintenance script (off/on/sleep 60) inside container.

## 2018-03-18 3.5 <dave at tiredofit dot ca>

* Add `STAGE` variable to be passed to PHP for Development/Production Purposes

## 2018-02-20 3.4 <dave at tiredofit dot ca>

* Add Reverse Proxy Detection

## 2018-02-14 3.3 <dave at tiredofit dot ca>

* Remove Redundant Entrypoint
* Fix Paths for enabled php modules

## 2018-02-01 3.2 <dave at tiredofit dot ca>

* Fix PHP Timezone Issue
* Add Zabbix Scripts

## 2017-11-30 edge-3.1 <dave at tiredofit dot ca>

* Switched to Edge Base


## 2017-09-17 3.1 <dave at tiredofit dot ca>

* Fix Issue with PHP XDebug
* Added Imagick Extension

## 2017-08-27 3.0 <dave at tiredofit dot ca>

* Big change (in image size) due to adding all available PHP Extensions
* Debug Mode via XDebug set via Environment Variables
* All PHP Extensions able to be enabled of disabled via Environment Variables

## 2017-07-12 2.6 <dave at tiredofit dot ca>

* Added Checking to wait to start services in sequence

## 2017-07-12 2.5 <dave at tiredofit dot ca>

* Added Composer, memcached, and sqlite extensions

## 2017-07-06 2.4 <dave at tiredofit dot ca>

* Added proper logging for php-fpm

## 2017-07-06 2.3 <dave at tiredofit dot ca>

* Add PHP_TIMEOUT

## 2017-07-03 2.2 <dave at tiredofit dot ca>

* Added Logrotate

## 2017-07-01 2.1 <dave at tiredofit dot ca>

* Sanity Check and write initialization state to /tmp/.container/*service name
* Added MSMTP to take place of sendmail


## 2017-06-23 2.0 <dave at tiredofit dot ca>

* s6.d Process Seperation
* PHP-FPM run as NGINX
* Nginx Zabbix Checks set to port 73
* Nginx Uses conf.d file for Loading Site


## 2017-05-29 1.3 <dave at tiredofit dot ca>

* Tracking Alpine 3.4
* PHP 5.6

## 2017-04-07 1.2 <dave at tiredofit dot ca>

* Rebase

## 2017-02-08 1.1 <dave at tiredofit dot ca>

* Added mariadb-client

## 2017-02-08 1.0 <dave at tiredofit dot ca>

* Initial Release
* Alpine:edge
* PHP7
* Zabbix

