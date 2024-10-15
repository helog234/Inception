#!/bin/bash

# Charger les secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_NAME=$(printenv DB_NAME)
DB_USER=$(printenv DB_USER)

# Vérifier que les variables d'environnement sont définies
if [[ -z "$DB_PASSWORD" || -z "$DB_ROOT_PASSWORD" || -z "$DB_NAME" || -z "$DB_USER" ]]; then
    echo "Erreur : Les variables d'environnement ne sont pas correctement définies."
    exit 1
fi

# Codes de couleurs ANSI pour le logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Réinitialiser la couleur

echo -e "${YELLOW}Démarrage du script d'initialisation de MariaDB...${NC}"

# S'assurer que les répertoires ont les bonnes permissions
echo "[DB config] Configuration des permissions pour MariaDB..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialiser la base de données si nécessaire
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[DB config] Initialisation du répertoire de données de MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "[DB config] Répertoire de données initialisé."
else
    echo "[DB config] Répertoire de données déjà existant, initialisation ignorée."
fi

# Démarrer MariaDB en arrière-plan
echo "[DB config] Démarrage de MariaDB..."
/usr/bin/mysqld --user=mysql --console --skip-networking=0 --skip-bind-address &
sleep 5

# Attendre que MariaDB soit prêt
echo "[DB config] Attente que MariaDB soit prêt..."
until mysqladmin ping --silent; do
    echo "MariaDB n'est pas encore prêt..."
    sleep 2
done

echo "[DB config] MariaDB est prêt."

# Remplacer les variables dans le fichier init.sql
sed -i "s/\${DB_ROOT_PASSWORD}/$DB_ROOT_PASSWORD/" /tmp/init.sql
sed -i "s/\${DB_USER}/$DB_USER/" /tmp/init.sql
sed -i "s/\${DB_PASSWORD}/$DB_PASSWORD/" /tmp/init.sql
sed -i "s/\${DB_NAME}/$DB_NAME/" /tmp/init.sql

# Exécuter le script SQL d'initialisation
echo "[DB config] Exécution du script d'initialisation SQL..."
mysql -u root < /tmp/init.sql

# Arrêter MariaDB
echo "[DB config] Arrêt de MariaDB après l'initialisation..."
mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown

echo "[DB config] Initialisation de MariaDB terminée."

# Modifier la configuration pour autoriser les connexions distantes
echo "[DB config] Configuration pour autoriser les connexions distantes..."
sed -i "s|skip-networking|skip-networking = 0|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address = 0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Démarrer MariaDB en mode serveur
echo "[DB config] Démarrage de MariaDB en mode serveur..."
exec /usr/bin/mysqld --user=mysql --console
