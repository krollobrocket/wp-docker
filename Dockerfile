ARG PHP_VERSION=$PHP_VERSION

FROM php:${PHP_VERSION}-apache

# Update and install packages.
RUN apt-get update
RUN apt-get install -y \
    curl \
    nano \
    zip \
    zlib1g \
    gcc \
    make \
    libzip-dev \
    libpng-dev \
    libwebp-dev \
    libfreetype-dev \
    libjpeg62-turbo-dev

# Configure and install GD extension.
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd

# Install PDO extension.
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install redis extension.
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Install composer.
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install wp-cli.
RUN composer global require wp-cli/wp-cli

# Enable mod rewrite.
RUN a2enmod rewrite
