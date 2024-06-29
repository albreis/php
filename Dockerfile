# 2022 update
FROM php:8.2-apache

# Install environment dependencies
RUN apt-get update
# gd
RUN apt-get install -y build-essential libwebp-dev openssl nginx libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev zlib1g-dev libzip-dev gcc g++ make vim unzip curl git jpegoptim optipng pngquant gifsicle locales libonig-dev nodejs 
RUN docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp && docker-php-ext-install gd
# gmp
RUN apt-get install -y --no-install-recommends libgmp-dev
RUN docker-php-ext-install gmp
# pdo_mysql
RUN docker-php-ext-install pdo_mysql mbstring
# pdo
RUN docker-php-ext-install pdo
# opcache
RUN docker-php-ext-enable opcache
# exif
RUN docker-php-ext-install exif
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install bcmath
# zip
RUN docker-php-ext-install zip
RUN apt-get autoclean -y
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/pear/
# Install Postgre PDO
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN pecl install redis && docker-php-ext-enable redis
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends
RUN pecl install imagick && docker-php-ext-enable imagick
RUN a2enmod rewrite
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

COPY ./php.ini $PHP_INI_DIR/conf.d/custom.ini

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
