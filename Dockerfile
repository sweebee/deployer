FROM php:7.3-fpm

MAINTAINER Wiebe Nieuwenhuis <info@wiebenieuwenhuis.nl>

# apt-get required packages
RUN apt-get update -yqq && apt-get install -yqq apt-utils libzip-dev rsync && apt-get install -yqq git openssh-client zlib1g-dev iputils-ping gnupg2 zip npm

# PHP extension installation
RUN docker-php-ext-install pdo_mysql zip bcmath

# Install iconv and gd
RUN apt-get install -yqq libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install NPM, Yarn & Gulp
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn gulp

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Environmental variables
ENV COMPOSER_HOME /root/.composer
ENV COMPOSER_CACHE_DIR /cache
ENV PATH /root/.composer/vendor/bin:$PATH

# Install composer parallel downloads
RUN composer global require "hirak/prestissimo:^0.3"

# Install deployer
RUN composer global require "deployer/deployer"
RUN composer global require --dev "deployer/recipes"
