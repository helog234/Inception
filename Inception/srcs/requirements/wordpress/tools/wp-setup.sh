#!/bin/bash

# Lire les secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_super_password)
WP_SECOND_USER_PASSWORD=$(cat /run/secrets/wp_random_password)

# Codes de couleurs ANSI for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Reset color

# Vérifier que les secrets sont chargés correctement
if [[ -z "$DB_PASSWORD" || -z "$WP_ADMIN_PASSWORD" || -z "$WP_SECOND_USER_PASSWORD" ]]; then
    echo "Error: Secrets are not properly loaded."
    exit 1
fi

# Attendre que MariaDB soit disponible
TIMEOUT=60
until mysqladmin ping -h mariadb -u"${DB_USER}" -p"${DB_PASSWORD}" --silent >/dev/null 2>&1 || [ $TIMEOUT -eq 0 ]; do
    echo "Waiting for MariaDB to be available..."
    sleep 2
    TIMEOUT=$((TIMEOUT-2))
done

if [ $TIMEOUT -eq 0 ]; then
    echo "Error: MariaDB did not become available in time."
    exit 1
fi

# Configurer WordPress (en modifiant wp-config.php via WP-CLI)
cd /var/www/wordpress
if [ ! -f wp-config.php ]; then
   wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="mariadb" --allow-root
fi

# Installer WordPress si ce n'est pas déjà fait
if ! wp core is-installed --allow-root; then
    wp core install --url=${DOMAIN_NAME} --title="Inception" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --skip-email --allow-root
fi
echo -e "${YELLOW}IS THIS HERE ? ${NC}"
# Ajouter un deuxième utilisateur
if ! wp user get ${WP_SECOND_USER} --allow-root > /dev/null 2>&1; then
    wp user create ${WP_SECOND_USER} ${WP_SECOND_USER_EMAIL} --role=editor --user_pass=${WP_SECOND_USER_PASSWORD} --allow-root
fi

# Démarrer PHP-FPM en mode foreground
exec php-fpm82 -F



