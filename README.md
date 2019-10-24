#PRINCIPE
PyShort à un raccourcisseur d'URL compatible avec une connexion sécurisé reposant sur une base SQL 

#INSTALLATION & MISE A JUR
Si PyShort est déjà installé, commencer par supprimer l'image : docker rm -f pyshort
puis télécharger la dernière version : docker pull f80hub/pyshort:latest
enfin installer simplement par : 

docker run --restart=always -p 443:443 --name pyshort -d f80hub/pyshort:latest <domain> 443 ssl
