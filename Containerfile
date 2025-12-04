# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE \
    DISTRO \
    DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

LABEL \
        org.opencontainers.image.title="Nginx PHP-FPM" \
        org.opencontainers.image.description="PHP Interpreter w/Web server" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/nginx-php-fpm" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-nginx-php-fpm/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-nginx-php-fpm.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    PHP_BASE

ENV \
    PHP_MODULE_ENABLE_APCU=TRUE \
    PHP_MODULE_ENABLE_BCMATH=TRUE \
    PHP_MODULE_ENABLE_BZ2=TRUE \
    PHP_MODULE_ENABLE_CTYPE=TRUE \
    PHP_MODULE_ENABLE_CURL=TRUE \
    PHP_MODULE_ENABLE_DOM=TRUE \
    PHP_MODULE_ENABLE_EXIF=TRUE \
    PHP_MODULE_ENABLE_FILEINFO=TRUE \
    PHP_MODULE_ENABLE_GD=TRUE \
    PHP_MODULE_ENABLE_ICONV=TRUE \
    PHP_MODULE_ENABLE_IMAP=TRUE \
    PHP_MODULE_ENABLE_INTL=TRUE \
    PHP_MODULE_ENABLE_MBSTRING=TRUE \
    PHP_MODULE_ENABLE_MYSQLI=TRUE \
    PHP_MODULE_ENABLE_MYSQLND=TRUE \
    PHP_MODULE_ENABLE_OPCACHE=TRUE \
    PHP_MODULE_ENABLE_OPENSSL=TRUE \
    PHP_MODULE_ENABLE_PDO=TRUE \
    PHP_MODULE_ENABLE_PDO_MYSQL=TRUE \
    PHP_MODULE_ENABLE_PGSQL=TRUE \
    PHP_MODULE_ENABLE_PHAR=TRUE \
    PHP_MODULE_ENABLE_SESSION=TRUE \
    PHP_MODULE_ENABLE_SIMPLEXML=TRUE \
    PHP_MODULE_ENABLE_TOKENIZER=TRUE \
    PHP_MODULE_ENABLE_XML=TRUE \
    PHP_MODULE_ENABLE_XMLREADER=TRUE \
    PHP_MODULE_ENABLE_XMLWRITER=TRUE \
    PHPFPM_USER="php" \
    PHPFPM_GROUP="www-data" \
    CONTAINER_ENABLE_MESSAGING=TRUE \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    IMAGE_NAME="nfrastack/nginx-php-fpm" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-nginx-php-fpm/"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

RUN echo "" && \
    export PHP_BUILD_DEPS_ALPINE="  \
                                    build-base \
                                    php${PHP_BASE/./}-dev \
                                 " \
                                 && \
    export PHP_BUILD_DEPS_DEBIAN="  \
                                  " \
                                  && \
    export PHP_RUN_DEPS_ALPINE="  \
                                    mariadb-client \
                                    mariadb-connector-c \
                                    postgresql-client \
                                " \
                           && \
    export PHP_8_4_RUN_DEPS_ALPINE=" \
                                        gnu-libiconv \
                                        mariadb-connector-c \
                                        " && \
    \
    export PHP_8_3_RUN_DEPS_ALPINE=" \
                                        gnu-libiconv \
                                        mariadb-connector-c \
                                        " && \
    \
    export PHP_8_2_RUN_DEPS_ALPINE=" \
                                        gnu-libiconv \
                                        mariadb-connector-c \
                                        " && \
    \
     export PHP_8_1_RUN_DEPS_ALPINE=" \
                                        gnu-libiconv \
                                        mariadb-connector-c \
                                        " && \
    \
    export PHP_8_0_RUN_DEPS_ALPINE=" \
                                        gnu-libiconv \
                                        mariadb-connector-c \
                                        " && \
    \
    export PHP_7_4_RUN_DEPS_ALPINE=" \
                                        mariadb-connector-c \
                                        " && \
    \
    export PHP_7_3_RUN_DEPS_ALPINE=" \
                                        mariadb-connector-c \
                                        " && \
    \
    export PHP_7_2_RUN_DEPS_ALPINE=" \
                                        " && \
    \
    export PHP_7_1_RUN_DEPS_ALPINE=" \
                                        " && \
    \
    export PHP_7_0_RUN_DEPS_ALPINE=" \
                                        " && \
    \
    export PHP_5_6_RUN_DEPS_ALPINE=" \
                                        " && \
    \
    export PHP_RUN_DEPS_DEBIAN=" \
                                    ca-certificates \
                                    git \
                                    mariadb-client \
                                    php-pear \
                                    postgresql-client \
                                " \
    export PHP_8_4_RUN_DEPS_DEBIAN=" \
                                    " && \
    \
    export PHP_8_3_RUN_DEPS_DEBIAN=" \
                                    " && \
    \
    export PHP_8_2_RUN_DEPS_DEBIAN=" \
                                    " && \
    \
    export PHP_8_1_RUN_DEPS=_DEBIAN" \
                                        " && \
    \
    export PHP_8_0_RUN_DEPS_DEBIAN=" \
                                        " && \
    \
    export PHP_7_4_RUN_DEPS_DEBIAN=" \
                                        " && \
    \
    export PHP_7_3_RUN_DEPS_DEBIAN=" \
                                        " && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user php 9000 www-data && \
    add_user_group php www-data && \
    case "$(container_info distro)" in \
        "alpine" ) \
            case "${PHP_BASE}" in \
                8.[1-9] ) \
                        export _php_folder="/etc/php${PHP_BASE/./}" ; \
                        export _php_version="${PHP_BASE/./}" ; \
                        export build_gnupg=true ; \
                    ;; \
                8.0 | *  ) \
                        export _php_folder="/etc/php${PHP_BASE:0:1}" ; \
                        export _php_version="${PHP_BASE:0:1}" ; \
                        export build_gnupg=false ; \
                    ;; \
            esac \
        ;; \
        "debian" ) \
            export _php_version="${PHP_BASE}" ; \
            export _php_folder="/etc/php/${PHP_BASE}" ; \
            package repo add mariadb ; \
            package repo add postgres ; \
            package repo key https://packages.sury.org/php/apt.gpg suryphp.gpg ; \
            package repo add suryphp "https://packages.sury.org/php/ $(cat /etc/os-release |grep "VERSION=" | awk 'NR>1{print $1}' RS='(' FS=')') main" suryphp.gpg ; \
        ;; \
    esac ; \
    package update && \
    package upgrade && \
    package install \
                    PHP_BUILD_DEPS \
                    PHP_${PHP_BASE/./_}_BUILD_DEPS \
                    PHP_RUN_DEPS \
                    PHP_${PHP_BASE/./_}_RUN_DEPS \
                    && \
    \
    case "$(container_info distro)" in \
        "alpine" ) \
            package install $(apk search -q php${_php_version} | grep "^php${_php_version}" | sed -e "/-cgi/d" -e "/-apache2/d" -e "/-doc/d" -e "/-dbg/d") ; \
            #if [ -f "${_php_folder}"/conf.d/*magick*.ini ]; then mv "${_php_folder}"/conf.d/*magick*.ini /tmp; fi; \
            sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g" ${_php_folder}/php.ini ; \
        ;; \
        "debian" ) \
            package install $(apt-cache search php${_php_version} | awk '{print $1}' | sed -e "/-cgi/d" -e "/-dbgsym/d" -e "/-dev/d" -e "/-gmagick/d"  -e "/libapache2-mod/d" -e "/-libvirt/d" -e "/-yac/d") ; \
            sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g" ${_php_folder}/cli/php.ini ; \
        ;; \
    esac ; \
    \
    if [ -f /usr/sbin/php-fpm"${_php_version}" ] ; then ln -sf /usr/sbin/php-fpm"${_php_version}" /usr/sbin/php-fpm ; fi ; \
    if [ -f /usr/sbin/php-fpm"${PHP_BASE}" ] ; then ln -sf /usr/sbin/php-fpm"${PHP_BASE}" /usr/sbin/php-fpm ; fi ; \
    if [ -f /usr/bin/pecl"${_php_version}" ] ; then ln -sf /usr/bin/pecl"${_php_version}" /usr/sbin/pecl; fi ; \
    if [ -f /usr/bin/php"${_php_version}" ] ; then ln -sf /usr/bin/php"${_php_version}" /usr/sbin/php ; fi ; \
    if [ -f /usr/bin/phpize"${_php_version}" ] ; then ln -sf /usr/bin/phpize"${_php_version}" /usr/sbin/phpize ; fi ; \
    curl -sSLk https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    \
    rm -rf \
            "${_php_folder}"/environment/* \
            "${_php_folder}"/php-fpm.d/* \
            "${_php_folder}"/pools.d/* \
            && \
    \
    if [ "${_php_version}" = "5" ] ; then echo "suhosin.executor.include.whitelist = phar" >> "${_php_folder}"/php.ini ; fi ;  \
    \
    case "$(container_info distro)" in \
        "alpine" ) \
            #### Disabling any but core extensions - When using this image as a base for other images, you'll want to turn turn them on before running composer with the inverse of phpdisomd (phpenmod) to keep things clean
            mkdir -p "${_php_folder}"/conf.available/ && \
            for module in "${_php_folder}"/conf.d/*.ini; do \
                if [ ! -L "${module}" ] ; then \
                    if [ "$(echo $(basename $module) | grep -c '^[0-9][0-9].*')" = "0" ] ; then \
                        mv "${module}" "$(dirname ${module})/20_$(basename ${module})" ; \
                        module="$(dirname ${module})/20_$(basename ${module})"; \
                    fi ; \
                    if ! grep -w -i -q ";priority" "$module"; then \
                        echo ";priority=$(basename $module .ini | cut -d _ -f1)" >> $module ; \
                        mv "${module}" "${_php_folder}"/conf.available/$(basename "${module}" .ini | cut -c 4-).ini; \
                    fi; \
                fi; \
            done; \
            rm -rf "${_php_folder}"/conf.d/* ; \
            sed -i "s|;priority=00|;priority=10|g" "${_php_folder}"/conf.available/opcache.ini ; \
            php_env_modules_enabled="$(set -o posix; set | sort | grep "^PHP_MODULE_ENABLE_.*=" | grep -i TRUE | cut -d _ -f 4 | cut -d = -f 1 |  tr [A-Z] [a-z])" ; \
            for module in $php_env_modules_enabled ; do \
                if [ -f "${_php_folder}"/conf.available/"${module}".ini ] ; then \
                    priority=$(cat "${_php_folder}"/conf.available/"${module}".ini | grep ";priority" | cut -d = -f2) ; \
                    ln -sf "${_php_folder}"/conf.available/"${module}".ini "${_php_folder}"/conf.d/"${priority}"-"${module}".ini ; \
                fi ; \
            done ; \
            if [ "${_php_version}" != "8" ] ; then \
                if [ -f "${_php_folder}"/conf.available/json.ini ] ; then \
                          priority=$(cat "${_php_folder}"/conf.available/json.ini | grep ";priority" | cut -d = -f2) ; \
                    ln -sf "${_php_folder}"/conf.available/json.ini "${_php_folder}"/conf.d/"${priority}"-json.ini ; \
                fi ; \
            fi ; \
        ;; \
        "debian" ) \
            update-alternatives --set php /usr/bin/php${PHP_BASE} ; \
            for f in /etc/php/${PHP_BASE}/mods-available/*.ini; do phpdismod $(basename $f .ini); done; \
            php_env_modules_enabled="$(set -o posix; set | sort | grep "^PHP_MODULE_ENABLE_.*=" | grep -i TRUE | cut -d _ -f 4 | cut -d = -f 1 |  tr A-Z a-z)" ; \
            for module in $php_env_modules_enabled ; do phpenmod ${module} ; done ; \
            if [ "${PHP_BASE}" = "7.3" ] || [ "${PHP_BASE}" = "7.4" ]; then phpenmod json ; fi ; \
            find /etc/php/ -mindepth 1 -maxdepth 1 -type d -not -name ${PHP_BASE} -exec rm -rf '{}' \; 2>/dev/null ; \
        ;; \
    esac ; \
    \
    package remove \
                    PHP_BUILD_DEPS \
                    PHP_${PHP_BASE/./_}_BUILD_DEPS \
                    && \
    package cleanup && \
    rm -rf \
            /root/.composer

EXPOSE 9000

COPY rootfs /
