FROM alpine:3.19

# # Install MariaDB
# RUN		apk update && apk upgrade &&\
# 		apk add mariadb mariadb-client

# # Copy MariaDB configuration files
# COPY	./tools/init-db.sh /tmp/init-db.sh
# # COPY	./tools/init.sql /tmp/init.sql
# RUN		chmod +x /tmp/init-db.sh

# # Run MariaDB configuration script as entry point
# ENTRYPOINT	[ "sh", "/tmp/init-db.sh" ]
# Installer mariadb et mariadb client
RUN apk -U upgrade && apk add mariadb mariadb-client

#initialiser le nouveau répertoir en mode root
#--datadir=/var/lib/mysql= fichiers de base stocké dans /var/lib/mysql ce sera
#le "datadir" par défaut pour stocker les bases de données.
RUN mariadb-install-db --user=root --datadir=/var/lib/mysql

#création du répertoire nécessaire pour stocker les fichiers
#temporaires comme les sockets
RUN mkdir /run/mysqld/

#copier le script et le fichier sql pour initaliser selon nos besoins
COPY ./tools/init-db.sh /tmp/init-db.sh
COPY ./tools/init.sql /tmp/init.sql

#entrée du conteneur exécuté via le script
ENTRYPOINT	[ "sh", "/tmp/init-db.sh" ]
