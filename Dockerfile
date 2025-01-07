FROM php:8.2-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev zip unzip git libsqlite3-dev pkg-config && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip pdo pdo_mysql pdo_sqlite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

CMD ["php-fpm"]
