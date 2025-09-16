### PRODUCTION
FROM docker.digiserv.net/digiserv/php8-fpm-nginx-prod:8.4.12-bookworm as production
WORKDIR /
ARG env
ARG doppler_token

RUN apt update
RUN apt -y install supervisor nodejs postgresql-client apt-transport-https ca-certificates curl gnupg
RUN curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | tee /etc/apt/sources.list.d/doppler-cli.list
RUN apt update
RUN apt install doppler

COPY .docker/prod/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh
RUN mkdir -p /var/run/php

COPY ".docker/prod/nginx/nginx.conf" /etc/nginx/nginx.conf
COPY ".docker/prod/nginx/site.conf" /etc/nginx/sites-available/default
COPY ".docker/prod/php/www.conf" /usr/local/etc/php-fpm/www.conf
COPY .docker/prod/supervisor/web.ini /etc/supervisor/conf.d/web.conf

COPY src /application/src

#RUN echo "$env" > /application/src/.env

ENTRYPOINT /docker-entrypoint.sh
