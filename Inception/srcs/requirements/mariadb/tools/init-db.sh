#!/bin/bash

# Charger les secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_NAME=$(printenv DB_NAME)
DB_USER=$(printenv DB_USER)

# Vérifier que les variables d'environnement sont définies
if [[ -z "$DB_PASSWORD" || -z "$DB_ROOT_PASSWORD" || -z "$DB_NAME" || -z "$DB_USER" ]]; then
    echo -e "${RED}DB:Erreur : Les variables d'environnement ne sont pas correctement définies.${NC}"
    exit 1
fi

# couleur <3
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}DB:Démarrage du script d'initialisation de MariaDB...${NC}"

# S'assurer que les répertoires ont les bonnes permissions
echo "DB:Configuration des permissions pour MariaDB..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialiser la base de données si nécessaire
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "DB:Initialisation du répertoire de données de MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo -e "${GREEN}DB: Répertoire de données initialisé.${NC}"
else
    echo "DB: Répertoire de données déjà existant, initialisation ignorée."
fi

# Démarrer mariadb en arrière-plan
echo "DB: Démarrage de MariaDB..."
/usr/bin/mysqld --user=mysql --console --skip-networking=0 --skip-bind-address &
sleep 5

#loop pour attendre que mariadbd soit pret
echo "DB: Attente que MariaDB soit prêt..."
until mysqladmin ping --silent; do
    echo -e "${YELLOW}MariaDB n'est pas encore prêt...${NC}"
    sleep 2
done

echo -e "${GREEN}DB: MariaDB est prêt.${NC}"

# Remplacer les variables dans le fichier init.sql
#obligée de le faire là car autrement impossible de
#les récupérer automatiquement depuis le fichier sql
sed -i "s/\${DB_ROOT_PASSWORD}/$DB_ROOT_PASSWORD/" /tmp/init.sql
sed -i "s/\${DB_USER}/$DB_USER/" /tmp/init.sql
sed -i "s/\${DB_PASSWORD}/$DB_PASSWORD/" /tmp/init.sql
sed -i "s/\${DB_NAME}/$DB_NAME/" /tmp/init.sql

#excution du script sql pour créer les user et droits d'accès
echo "DB: Exécution du script d'initialisation SQL..."
mysql -u root < /tmp/init.sql

# Arrêter MariaDB
echo "DB: Arrêt de MariaDB après l'initialisation..."
mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown

echo -e "${GREEN}DB: Initialisation de MariaDB terminée.${NC}"

#modifications des données de config
#difficultés à connecter au bon port et domaine si je ne précisais pas 
#le skip-networking à 0
#0.0.0.0 permet d'écouter sur le réseau (inception dans notre cas)
echo "DB: Configuration pour autoriser les connexions distantes..."
sed -i "s|skip-networking|skip-networking = 0|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address = 0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# démarrage de mariadb en mode serveur et définitif (avec les bonnes configurations)
echo "DB: Démarrage de MariaDB en mode serveur..."
exec /usr/bin/mysqld --user=mysql --console
