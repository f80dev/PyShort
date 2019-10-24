<h1>PRINCIPE</h1>
PyShort à un raccourcisseur d'URL compatible avec une connexion sécurisé reposant sur une base SQL. Elle se destine principalement au programmeur souhaitant disposé d'un système pour raccourcir les URL à moindre coût. 

<h1>INSTALLATION & MISE A JOUR</h1>
Si PyShort est déjà installé, commencer par supprimer l'image : 

<pre>docker rm -f pyshort</pre>

puis télécharger la dernière version : 

<pre>
docker pull f80hub/pyshort:latest
</pre>

enfin créer un répertoire (par exemple /root/data) pour héberger la base de données 
et un répertoire /root/certs pour stocker le certificat du serveur si vous souhaitez
une connexion sécurisée (fichiers fullchain.pem et privkey.pem)
puis installer l'image docker simplement par : 
<pre>
docker run --restart=always -v /root/datas:/app/datas -v /root/certs:/app/certs -p 443:443 --name pyshort -d f80hub/pyshort:latest domain_server 443 ssl
</pre>

le paramètre SSL doit être ajouté si vous souhaitez une
connexion sécurisée. 



<h1>FONCTIONNEMENT</h1>
La réduction se fait via l'usage de l'API short.
Celle-ci est utilisable en 
<pre>
GET /short?url=votre_url&format=text|qrcode
</pre>
ou en POST en plaçant votre url dans le corps.

En précisant le format text ou qrcode, l'API répond par
une url ou directement par une image au format PNG
correspondant au QRCode de l'url


