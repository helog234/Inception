#d'après moi avant dernière version stable d'Alpine
#les images d'Alpine sont plus légères que Debian
FROM Alpine:3.19

#apk commande de Alpine pour la gestion des packets
#update si déjà présents et add dans le cas contraire
#installation de ngnix et openssl
RUN apk update && apk add nginx openssl

#copier/remplace la configuration de ngnix par défaut
COPY conf/nginx.conf /etc/nginx/nginx.conf

#req = générer un certificat SSL, x509 précise le type de certificat
#-nodes=évite mdp empechant de build
#indiquer à OpenSSL où stocker le certificat et la clef SSL
#-subj=évite prompt empéchant build
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/inception.key \
  -out /etc/ssl/certs/inception.crt \
  -subj "/CN=localhost"

#root principal
RUN chmod 755 /var/www/html

#utilisateur principal
RUN chown -R www-data:www-data /var/www/html

#démarrer ngnix en avant-plan (daemon off)
#évite que le process soit indépendant du PID 1
CMD ["nginx", "-g", "daemon off;"]