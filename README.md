<h1>PRINCIPE</h1>
PyShort à un raccourcisseur d'URL compatible avec une connexion sécurisé reposant sur une base SQL. Elle se destine principalement au programmeur souhaitant disposé d'un système pour raccourcir les URL à moindre coût. 

<h1>INSTALLATION & MISE A JOUR</h1>
Si PyShort est déjà installé, commencer par supprimer l'image : docker rm -f pyshort
puis télécharger la dernière version : docker pull f80hub/pyshort:latest
enfin installer simplement par : 

docker run --restart=always -p 443:443 --name pyshort -d f80hub/pyshort:latest <domain> 443 ssl

<h1>FONCTIONNEMENT</h1>
