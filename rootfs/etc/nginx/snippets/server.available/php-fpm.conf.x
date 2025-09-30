# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

fastcgi_pass php-fpm-upstream;
fastcgi_read_timeout {{PHP_TIMEOUT}};
fastcgi_send_timeout {{PHP_TIMEOUT}};
proxy_http_version 1.1;
proxy_set_header Connection "";
