Commande docker run:
#
```
docker run (nom image)
```
#
flags:

!!! Avant le nom de l'image !!!

-rm = permet d'éviter de devoir supprimer le container après l'avoir stoppé

-it = ouvrir avec l'interface

-p (hostport):(containerport) = lie le port de la machine au port du container

-d = détache notre terminal du container

!!! Après le nom de l'image !!!

sh = écrase la commande (si il y en a une)
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