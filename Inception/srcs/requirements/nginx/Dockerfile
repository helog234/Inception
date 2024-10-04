# Utiliser Alpine comme base
FROM alpine:3.19

# Installer Nginx et OpenSSL
RUN apk update && apk add --no-cache nginx openssl bash

# Créer le répertoire pour les certificats SSL
RUN mkdir -p /etc/nginx/ssl

## Générer un certificat SSL auto-signé avec OpenSSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/inception.key \
-out /etc/ssl/certs/inception.crt \
-subj "/C=CH/ST=VD/L=Lausanne/O=42Network/OU=hgandar/CN=hgandar.42.fr"

# Créer le répertoire pour le contenu du site (WordPress sera monté ici)
RUN mkdir -p /var/www/wordpress

# Copier la configuration Nginx dans le conteneur
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Exposer le port 443 pour le HTTPS
EXPOSE 443

# Démarrer Nginx en avant-plan pour éviter que le conteneur ne se termine
CMD ["nginx", "-g", "daemon off;"]

