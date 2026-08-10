FROM serversideup/php:8.2-fpm-nginx

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip nginx \
    libzip-dev libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN php artisan filament:upgrade

# Copy Nginx Config
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Nginx Configuration
RUN echo 'server { \
    listen 80; \
    root /var/www/public; \
    index index.php; \
    location / { try_files $uri $uri/ /index.php?$query_string; } \
    location ~ \.php$ { \
        fastcgi_pass 127.0.0.1:9000; \
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
        include fastcgi_params; \
    } \
}' > /etc/nginx/sites-available/default

EXPOSE 80

CMD service nginx start && php-fpm