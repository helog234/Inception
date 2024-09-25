#!/bin/bash

# Lire les secrets depuis les fichiers Docker secrets
SQL_PASSWORD=$(cat /run/secrets/sql_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_boss_password)
WP_SECOND_USER_PASSWORD=$(cat /run/secrets/wp_random_password)

#attendre que MariaDB soit accessible
until mysqladmin ping -h mariadb --silent; do
    echo "Waiting for MariaDB to be available..."
    sleep 2
done

# Configurer wordpress (en modifiant wp-config.php grâce à CLI)
#et utilisant les variable de .env
wp config create --dbname=${SQL_DATABASE} --dbuser=${SQL_USER} --dbpass=${SQL_PASSWORD} --dbhost=mariadb --allow-root

#Initialiser la base de données wordpress
wp core install --url=${DOMAIN_NAME} --title="Inception" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --skip-email --allow-root

#ajouter 2eme user
wp user create ${WP_SECOND_USER} ${WP_SECOND_USER_EMAIL} --role=editor --user_pass=${WP_SECOND_USER_PASSWORD} --allow-root

# lancer PHP-FPM en tant que processus principal
exec php-fpm7 -F
