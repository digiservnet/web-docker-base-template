### PRODUCTION
FROM digiserv/php8-fpm-nginx-prod:8.3.12-bookworm as production
WORKDIR /
ARG env

RUN apt update
RUN apt -y install supervisor nodejs

COPY "docker-entrypoint.sh" /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh
RUN mkdir -p /var/run/php

COPY "nginx/nginx.conf" /etc/nginx/nginx.conf
COPY "nginx/site.conf" /etc/nginx/sites-available/default
COPY "php/www.conf" /usr/local/etc/php-fpm/www.conf

COPY "supervisor/web.conf" /etc/supervisor/conf.d/web.conf

COPY src /application/src

RUN echo "$env" > /application/src/.env

ENTRYPOINT /docker-entrypoint.sh
