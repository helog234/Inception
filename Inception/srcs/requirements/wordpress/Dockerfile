FROM alpine:3.19

#installer
RUN apk add --no-cache \
    php7 \
    php7-fpm \
    php7-mysqli \
    php7-json \
    php7-curl \
    php7-xml \
    php7-mbstring \
    php7-phar \
    php7-zip \
    php7-openssl \
    curl \
    less \
    mariadb-client \
    bash

#Télécharger et installer WP-CLI (WordPress Command Line Interface)
#qui permet de pouvoir automatiser les pages de setup de wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

#créer le répertoire pour WordPress
RUN mkdir -p /var/www/wordpress

#le définir comme working directory
WORKDIR /var/www/wordpress

# télécharger wordpress via cli dans le working directory
RUN wp core download --allow-root

# Copier le script d'installation WordPress
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

#exposer le port 9000 (pour php-fpm)
EXPOSE 9000

# Lancer php-fpm
CMD ["php-fpm7", "-F"]
