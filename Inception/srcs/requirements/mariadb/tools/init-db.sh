#!/bin/bash

# Load secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_super_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Codes de couleurs ANSI for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Reset color

echo -e "${YELLOW}Opening script...${NC}"
# echo "[DB config] Waiting for MariaDB to be ready..."
# until mysqladmin ping -h "localhost" --silent; do
#     echo "Waiting for MariaDB to start..."
#     sleep 2
# done

echo "[DB config] Running initial SQL setup..."
sed -i "s/\$DB_ROOT_PASSWORD/$DB_ROOT_PASSWORD/" /tmp/init.sql
sed -i "s/\$DB_USER/$DB_USER/" /tmp/init.sql
sed -i "s/\$DB_PASSWORD/$DB_PASSWORD/" /tmp/init.sql
sed -i "s/\$DB_NAME/$DB_NAME/" /tmp/init.sql

/usr/bin/mysqld --user=mysql --bootstrap < /tmp/init.sql
echo "[DB config] MySQL configuration done."

echo "[DB config] Allowing remote connections to MariaDB"
sed -i "s|skip-networking|skip-networking = 0|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec /usr/bin/mysqld --no-defaults  --user=root --console



# #!/bin/bash

# # Load secrets
# DB_PASSWORD=$(cat /run/secrets/db_password)
# WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_super_password)
# DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# # Codes de couleurs ANSI for logging
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# NC='\033[0m' # Reset color

# echo -e "${YELLOW}Opening script...${NC}"


# echo "[DB config] Configuring MariaDB..."

# # Set up MariaDB permissions and directories
# echo "[DB config] Granting MariaDB daemon run permissions..."
# mkdir -p /run/mysqld
# chown -R mysql:mysql /run/mysqld

# echo "[DB config] Installing MySQL Data Directory..."
# chown -R mysql:mysql /var/lib/mysql
# mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
# echo "[DB config] MySQL Data Directory done."

# # Start MariaDB without grant-tables for initial setup
# echo "[DB config] Starting MariaDB without skip-grant-tables for initial setup..."
# # /usr/bin/mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
# # /usr/bin/mysqld --user=mysql --bootstrap

# # Wait for MariaDB to start
# echo "[DB config] Waiting for MariaDB to start..."
# until mysqladmin ping -h "localhost" --silent; do
#     echo "Waiting for MariaDB..."
#     sleep 2
# done

# # Directly run MySQL commands in the script
# echo "[DB config] Running initial SQL setup..."
# mysql -u root -e "
#     CREATE DATABASE IF NOT EXISTS ${DB_NAME};
#     CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
#     GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION;
#     ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
#     ALTER USER 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

#     CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
#     GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';

#     CREATE USER IF NOT EXISTS '${WP_ADMIN_USER}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
#     GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${WP_ADMIN_USER}'@'%';

#     FLUSH PRIVILEGES;
# "

# # Stop MariaDB after initialization
# echo "[DB config] Stopping MariaDB after initialization..."
# mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown

# echo "[DB config] MariaDB initialization complete."

# # Modify the configuration to allow remote connections
# echo "[DB config] Allowing remote connections to MariaDB"
# sed -i "s|skip-networking|skip-networking = 0|g" /etc/my.cnf.d/mariadb-server.cnf
# sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# # Start MariaDB in normal mode (no skip-grant-tables)
# echo "[DB config] Starting MariaDB daemon on port 3306."
# exec /usr/bin/mysqld --user=mysql --console

# # Wait for MariaDB to be fully available
# echo "[DB config] Waiting for MariaDB to be ready..."
# until mysqladmin ping -h "localhost" --silent; do
#     echo "Waiting for MariaDB to be available..."
#     sleep 2
# done

# echo "[DB config] MariaDB is ready!"

