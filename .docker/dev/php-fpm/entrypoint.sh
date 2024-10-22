#!/bin/sh

## Run Supervisor
supervisord -c /etc/supervisor/supervisord.conf

## Run PHP
#/usr/local/sbin/php-fpm -O
