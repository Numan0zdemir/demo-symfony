# PHP 8.2 image ile başlıyoruz
FROM php:8.2-fpm

# Gerekli sistem bağımlılıklarını kuruyoruz
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev zip unzip git libsqlite3-dev pkg-config && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip pdo pdo_mysql pdo_sqlite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer'ı kuruyoruz
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Symfony projesinin çalışma dizinini belirtiyoruz
WORKDIR /app

# Uygulama dosyalarını Docker imajına kopyalıyoruz
COPY . .

# Bağımlılıkları kuruyoruz
RUN composer install

# PHP'nin production modunda çalışması için gerekli ayarlar
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Symfony'nin public dizinini expose ediyoruz
EXPOSE 9000

# Uygulamayı çalıştırmak için giriş komutunu belirliyoruz
CMD ["php-fpm"]
