#!/bin/bash

# lit les secrets, plus sur que ce soit % nécessaire mais ca pu faire
#bugger parfois
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_super_password)
WP_SECOND_USER_PASSWORD=$(cat /run/secrets/wp_random_password)

# la vie est plus simple avec des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# checker secrets chargés
if [[ -z "$DB_PASSWORD" || -z "$WP_ADMIN_PASSWORD" || -z "$WP_SECOND_USER_PASSWORD" ]]; then
    echo -e "${RED}WP: Error: Secrets are not properly loaded.${NC}"
    exit 1
fi

# check si mariadb est dispo
TIMEOUT=60
until mysqladmin ping -h mariadb -u"${DB_USER}" -p"${DB_PASSWORD}" --silent >/dev/null 2>&1 || [ $TIMEOUT -eq 0 ]; do
    echo -e "${YELLOW}WP: Waiting for MariaDB to be available...${NC}"
    sleep 2
    TIMEOUT=$((TIMEOUT-2))
done

if [ $TIMEOUT -eq 0 ]; then
    echo -e "${RED}WP: Error: MariaDB did not become available in time.${NC}"
    exit 1
fi

# Configurer wp: connection a mariadb, users (grâce à notre fichier de config et cli)
echo "Wordpress configuration"
cd /var/www/wordpress
if [ ! -f wp-config.php ]; then
    wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="mariadb" --allow-root
    echo -e "${GREEN}WP: connected to mariadb ${NC}"
fi

# installer wp (si pas déjà) et ajouter le user admin dessus
echo "Adding Admin user"
if ! wp core is-installed --allow-root; then
    wp core install --url=${DOMAIN_NAME} --title="Inception" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --skip-email --allow-root
    echo -e "${GREEN}WP: admin user added ${NC}"
fi

#ajout un deuxième utilisateur
if ! wp user get ${WP_SECOND_USER} --allow-root > /dev/null 2>&1; then
    wp user create ${WP_SECOND_USER} ${WP_SECOND_USER_EMAIL} --role=editor --user_pass=${WP_SECOND_USER_PASSWORD} --allow-root
    echo -e "${GREEN}WP: second user added ${NC}"
fi

# Démarrer PHP-FPM en mode foreground (avant plan)
#option -F pas en arrière plan, pour que Docker garde le conteneur exec tant que php est actif.
exec php-fpm82 -F



