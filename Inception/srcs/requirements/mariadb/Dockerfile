# Use Alpine as the base image
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

RUN apk -U upgrade && apk add mariadb mariadb-client
RUN mariadb-install-db --user=root --datadir=/var/lib/mysql
RUN mkdir /run/mysqld/
COPY ./tools/init-db.sh /tmp/init-db.sh
COPY ./tools/init.sql /tmp/init.sql

ENTRYPOINT	[ "sh", "/tmp/init-db.sh" ]
