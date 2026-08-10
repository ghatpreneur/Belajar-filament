FROM serversideup/php:8.2-fpm-nginx

# 1. Switch ke root untuk install ekstensi & atur permission
USER root

# 2. Install ekstensi PHP intl yang dibutuhkan oleh Filament
RUN apt-get update && apt-get install -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Set folder kerja
WORKDIR /var/www/html

# 4. Copy semua file project
COPY --chown=www-data:www-data . .

# 5. Install dependency Composer & upgrade Filament
RUN composer install --no-dev --optimize-autoloader --ignore-platform-req=ext-intl \
    && php artisan filament:upgrade

# 6. Pastikan permission folder storage & cache aman
RUN chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

# 7. Kembalikan ke user non-root
USER www-data