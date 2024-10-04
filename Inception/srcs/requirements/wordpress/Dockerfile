FROM alpine:3.19

# Installer PHP, PHP-FPM, et MariaDB-client
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-xml \
    php82-mbstring \
    php82-phar \
    php82-zip \
    php82-openssl \
    mariadb-client \
    curl bash less

# Configurer PHP-FPM pour écouter sur le port 9000
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Créer le répertoire de travail pour WordPress
RUN mkdir -p /var/www/wordpress

# Définir le répertoire de travail
WORKDIR /var/www/wordpress

# Télécharger WordPress via WP-CLI
RUN wp core download --allow-root

# Copier le script d'installation WordPress
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

# Exposer le port 9000
EXPOSE 9000

# Lancer le script de configuration à chaque démarrage
ENTRYPOINT [ "sh", "/usr/local/bin/wp-setup.sh" ]


