FROM alpine:3.19

# Installer mariadb et mariadb client et tini (PID1)
RUN apk -U upgrade && apk add --no-cache mariadb mariadb-client tini


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
# en ustilisant tini comme init pour éviter les problèmes PID 1
ENTRYPOINT ["/sbin/tini", "--", "sh", "/tmp/init-db.sh"]

