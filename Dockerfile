# Use the latest LTS version of PHP as the base image
FROM php:7.4-fpm

# Install required packages and extensions
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /todo

# Copy the Laravel application code into the container
COPY . .


# Rename env
RUN mv .env.sample .env

# Install dependencies
RUN composer install

# Expose port 80 for the server
EXPOSE 80

CMD ["php", "artisan", "migrate"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]