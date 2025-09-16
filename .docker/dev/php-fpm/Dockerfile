FROM docker.digiserv.net/digiserv/php8-fpm-dev:8.4.12-alpine
WORKDIR "/application"

RUN apk add --update zip supervisor mysql-client ca-certificates curl gnupg && rm -rf /tmp/* /var/cache/apk/*
#RUN curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
#RUN echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | tee /etc/apt/sources.list.d/doppler-cli.list
#RUN apt update
#RUN apt install doppler

RUN docker-php-ext-install pdo_mysql

RUN mkdir -p /etc/supervisor.d
COPY web.ini /etc/supervisor/conf.d

# Dev php.ini
COPY php.ini /usr/local/etc/php/php.ini

# Dev PHP-FPM config
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# Create a non-root user mapped to the host user for file ownership purposes
# when creating a file from within the container
RUN addgroup --gid 1000 dockeruser && \
    adduser --uid 1000 --ingroup dockeruser --gecos "" --disabled-password dockeruser

RUN mkdir /home/dockeruser/.composer
RUN chown -R dockeruser:dockeruser /home/dockeruser/.composer

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisord.conf"]
