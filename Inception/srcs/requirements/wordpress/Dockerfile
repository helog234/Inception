FROM alpine:3.19

#installer php, php-fpm (permet communication entre serveur et php) 
#et MariaDB-client pour se connecter à la db
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

# s'assure que le port d'écoute des requetres serveurs est celui que l'on veut
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

#install WP-CLI qui permet d'executer des lignes de commandes pour
#configurer wp avec les besoins du sujet (deux users etc)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Créer le répertoire de travail ou les fichiers wp seront placés
RUN mkdir -p /var/www/wordpress

# le défini comme répertoire de travail pour ce service
WORKDIR /var/www/wordpress

#télécharger wp grâce à wp-cli en mode root
RUN wp core download --allow-root

#remplace le script d'installation wp avec celui défini pour le projet
#et adapte les permission pour l'execution
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

# Expose port 9000
EXPOSE 9000

# Lance le script de configuration à chaque démarrage
ENTRYPOINT [ "sh", "/usr/local/bin/wp-setup.sh" ]


