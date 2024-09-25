FROM alpine:3.19

#installer
RUN apk update && apk add mariadb mariadb-client

#créer les dossiers
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

#ajout fichier de config
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

#créer volume pour persistance des données
VOLUME ["/var/lib/mysql"]

#copier script d'initialisation
COPY tools/script.sh /docker-entrypoint-initdb.d/

#rendre script exécutable
RUN chmod +x /docker-entrypoint-initdb.d/script.sh

#Démarrer avec mysqld_safe
CMD ["mysqld_safe"]
