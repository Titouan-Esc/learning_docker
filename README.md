### Commande docker run:
#
```
// Lance un container
docker run (nom image)

// Tue un container qui est lancé
docker container kill nom

// Stop un container lancé
docker stop nom
```
#
### flags:
```
!!! Avant le nom de l'image !!!

-rm = permet d'éviter de devoir supprimer le container après l'avoir stoppé

-it = ouvrir avec l'interface

-p (hostport):(containerport) = lie le port de la machine au port du container

-d = détache notre terminal du container

!!! Après le nom de l'image !!!

sh = écrase la commande (si il y en a une)
```
#
```
docker exec (nom image)
```
#

## Persistance de donnée Docker
#
### Bind Mount
```
docker run --mount type=bind,source=<url>,target=<url> uneimage
```
astuce commande bash = "$(pwd)" affiche le résultat de la commande "pwd" très pratique

Tout le dossier de la machine est partagé en direct avec le dossier data dans le container docker en temps réel.

#### Environnement Dev avec Bind Mount
Créer un sous dossier avec à l'intérieur les fichiers souhaité. Bind ce dossier là pour éviter d'écraser le dossier racine créé depuis le Dockerfile. En l'occurence node_modules ne sera plus dans le dossier app, car écrasé à cause du **Bind Mount**.
#
### Volumes

Commandes
```
docker volume create
docker volume inspect
docker volume ls
docker volume rm 
docker volume prune

// Pour monter un volume

docker run --mount type=volume,source=<nom-volume>,target=<path> uneimage
```

Récupérer le volume depuis un container lancé
```
docker run --volumes-from <nomcontainer> uneimage
```
Backup un volume

Deux étapes: 
- Lancer un container avec un volume qu'on veut backup
- Bind un dossier de notre host vers le container
```
docker run --mount type=volume,source=mydata,target=/data --mount type=bind,source="$(pwd)"/backup,target=/backup alpine tar -czf /backup/mydata.tar.gz /data
```

Restaurer un volume à partir d'un backup
```
docker run --mount type=volume,source=restore,target=/data --mount type=bind,source="$(pwd)",target=/backup alpine tar -xf /backup/mydata.tar.gz -C /data
```

### Persister une DB dans un volume Docker
Monter un volume dans le dossier où est stocké la db sur le container. Pour Mongo /data/db, créer votre base de donnée et il sera automatiquement créé dans le volume aussi.
#
## Docker et les réseaux

Commandes
```
docker network ls
docker network create
docker network rm
docker network inspect
docker network connect
docker network disconnect
docker network prune
docker network --network | --net
```

### Bridge
*Il est le réseau par défault sur docker*

Lorsque deux container sont lancé sur le network Bridge les deux peuvent communiqué entre eux avec leur addresse IPV4. Mais l'ip n'est pas le meilleur moyen de communication car nous ne l'a connaissons pas à l'avance.

Pour ce fait on va utiliser le DNS (le nom du container). Il est possile de le faire avec le réseaux par défaut avec ces commandes :
```
(lancement container 1)
docker run --name server1 -it alpine sh

(lancement container 2)
docker run --link server1 -it alpine sh
```
Mais on peut palier à cet inconvéniant en créant nos propres réseaux.
#
Créer nos propre network et faire communiquer deux container grâce à leur DNS.
```
// CREATION
docker network create nom

// Lancer un container sur le nouveau network
// (Important de lui préciser un nom, où le DNS ne marche pas)
docker run --network mynet --name server1 -d alpine
```

## Exercice
Faire communiquer un container avec un server Node.js avec un DB Mongo.
Le server va retourner un compteur, celui-ci sera stocker dans la DB Mongo qui sera sur un autre container que le server.

Le but étant de faire communiquer deux container sur notre réseaux Bridge personnalisé.
#
### Premier
Creer un container avec notre image Node et lier le port 80 du container et celui de notre machine.

- Build notre image docker depuis le DockerFile :
\
`docker build -t node-server .`
- Lancer le container avec l'image :
\
`docker run --name server --mount type=bind,source="$(pwd)"/src,target=/app/src -p 80:80 --network mynet node-server`
#
### Deuxième
Créer un volume pour persister les données de la DB Mongo.

`docker volume create mydb`
#
### Troisième
Créer un second container avec l'image mongo et le lier avec notre volume.

- Création du container mongo :
\
`docker run --mount type=volume,source=mydb,target=/data/db --name db -d mongo`

- Connecter container db sur le reseaux mynet :
\
`docker network connect mynet db`

- Créer une première collection sur la db :
    - Se connecter avec notre container:
    \
    `docker exec -it db sh`
    - Se connecter à la console mongo :
    \
    `mongosh`
    - Créer une db :
    \
    `use nom`
    - Créer notre collection :
    \
    `db.count.insertOne({ count: 0})`
    - Voir la collection :
    \
    `db.count.fingOne()`

Base de donnée fini !
#
### Quatrième
Relier les deux container enter eux pour qu'ils puissent communiquer entre eux. Pour cela on va créer un réseaux.

- Création du network
\
`docker network create mynet`
#