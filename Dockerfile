# Dockerfile for running the develop branch of Ampache, based on the work of PlusMinus0

FROM php:7.4-apache
MAINTAINER beeksma 

# Install everything
RUN apt-get update && \
    apt-get update && apt-get install -y -q git ffmpeg libgd3 libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-install pdo_mysql gettext gd \
    && a2enmod rewrite \
    && cd /var/www   \
    && git clone https://github.com/ampache/ampache.git html \
    && rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && cd html \
    && cp rest/.htaccess.dist rest/.htaccess \
    && cp play/.htaccess.dist play/.htaccess \
    && cp channel/.htaccess.dist channel/.htaccess \
    && composer install --prefer-source --no-interaction \
    && apt-get remove -y git \
    && apt-get autoremove -y \
    && apt-get clean \
    && mkdir -p /var/data \
    && chown -R www-data:www-data /var/www/html

VOLUME ["/var/www/html/config","/var/www/html/themes","/var/data"]

CMD ["apache2-foreground"]

