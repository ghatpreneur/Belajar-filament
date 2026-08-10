FROM serversideup/php:8.2-fpm-nginx

# 1. Switch ke root untuk atur izin folder & install composer
USER root

# 2. Set folder kerja sesuai standar serversideup
WORKDIR /var/www/html

# 3. Copy semua file project
COPY --chown=www-data:www-data . .

# 4. Install dependency Composer & upgrade Filament
RUN composer install --no-dev --optimize-autoloader \
    && php artisan filament:upgrade

# 5. Pastikan permission folder storage & cache aman
RUN chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

# 6. Kembalikan ke user non-root demi keamanan
USER www-data