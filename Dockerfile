FROM debian:stable-slim

RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y \
  ca-certificates \
  nginx-light \
  php-curl \
  php-fpm \
  php-gd \
  php-imagick \
  php-intl \
  php-mbstring \
  php-mysql \
  php-xml \
  php-zip \
  tar \
  unzip \
  wget

RUN adduser --disabled-password --gecos '' wp
RUN mkdir /wp
RUN chown -R wp:wp /wp

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
COPY ./src/wp-config.php wordpress/wp-config.php

COPY ./src/init-wp.sh /init-wp.sh
RUN chmod 700 /init-wp.sh

RUN rm -rf /etc/nginx/sites-*

COPY ./src/nginx.conf /etc/nginx/nginx.conf
RUN sed -i 's/www-data/wp/g' /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' \
  /etc/php/8.2/fpm/pool.d/www.conf

ENTRYPOINT ["/init-wp.sh"]
