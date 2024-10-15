FROM alpine:3.19

# installation de nginx et openssl et bash
#nginx est le serveur permettant de servir les données pour wp et mariadb
#openSSL permet de générer le certificat ssl qui permet lui-même se se connecter en https
RUN apk update && apk add --no-cache nginx openssl bash

#Créer le dossier pour les certificats ssl
#ajout de -p pour les dossiers liés si non-présents
RUN mkdir -p /etc/nginx/ssl

#générer un certificat SSL auto-signé qui permet le chiffrement des données et l'authentification du serveur
#même si le certificat est valide, comme il n'est pas reconnu officiellement il y aura un avertissement
#-x509= format du certificat
#-nodes= clé privée ne sera pas chiffrée (pas besoin de mdp pour l'utiliser).
#-days 365= durée de validité du certificat en jours
#-newkey rsa:2048=créaton d'une clé privée rsa de 2048bit (convention)
#-keyout=emplacement pour enregistrer la clé privée.
#-out=emplacement pour enregistrer le certificat public.
#-subj= détails du certificat.
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/inception.key \
-out /etc/ssl/certs/inception.crt \
-subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME"
#-subj "/C=CH/ST=VD/L=Lausanne/O=42Network/OU=hgandar/CN=hgandar.42.fr"

#Créé (si pas déjà le cas) le dossier pour wp afin qu'il sache ou chercher les données à servir
RUN mkdir -p /var/www/wordpress

# Copier la configuration Nginx définie pour le projet dans le contener
COPY conf/nginx.conf /etc/nginx/nginx.conf

#pour le https
EXPOSE 443

# lancer nginx en avant-plan pour éviter que le conteneur s'arrete
CMD ["nginx", "-g", "daemon off;"]

