#!/bin/bash

# Lire les secrets depuis les fichiers Docker secrets
SQL_PASSWORD=$(cat /run/secrets/sql_password)
SQL_ROOT_PASSWORD=$(cat /run/secrets/sql_root_password)

#attendre que MariaDB ait complètement démarré
until mysqladmin ping -h mariadb --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

#utiliser les variables d'environnement du .env lancé par 
#docker-compose.yml pour créer la db de données et l'user
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
mysql -e "FLUSH PRIVILEGES;"

#modifier le mdp de l'user root
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

#arrêter MariaDB avant de redémarrer via mysqld_safe
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

# Démarrer MariaDB en mode sûr
exec mysqld_safe

