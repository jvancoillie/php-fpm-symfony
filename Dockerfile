FROM php:fpm
MAINTAINER Jérémy Vancoillie <jeremy.vancoillie@gmail.com>

ENV SYMFONY_ENV=dev SYMFONY_DEBUG=1 

ADD symfony.ini /usr/local/etc/php/conf.d/

RUN apt-get update \
 && apt-get install -y git \
 libicu-dev \
 libcurl4-gnutls-dev \
 libmcrypt-dev \
 g++ \
 libxml2-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) opcache 

# Enable and configure xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update

EXPOSE 9000
