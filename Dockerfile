FROM php:7.2
RUN apt-get update
RUN apt-get install -y --no-install-recommends git zip libsqlite3-dev zlib1g-dev
RUN docker-php-ext-install zip && docker-php-ext-install phpunit
RUN curl --silent --show-error https://getcomposer.org/installer | php
COPY composer.json composer.json
RUN php composer.phar require "codeception/codeception"
RUN php composer.phar install -n --prefer-dist 
RUN touch storage/testing.sqlite storage/database.sqlite
RUN cp .env.testing .env
RUN php artisan migrate
RUN php artisan migrate --env=testing --database=sqlite_testing --force
RUN ./vendor/bin/codecept build
RUN ./vendor/bin/codecept run
COPY ./ /app/root/
CMD ["php","-S","0.0.0.0:80","-t","/app/root/public"]
