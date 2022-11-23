Commande docker run:
#
```
docker run (nom image)
```
#
flags:

!!! Avant le nom de l'image !!!

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

### Bind Mount
```
docker run --mount type=bind,source=<url>,target=<url> uneimage
```
astuce commande bash = "$(pwd)" affiche le résultat de la commande "pwd" très pratique

Tout le dossier de la machine est partagé en direct avec le dossier data dans le container docker en temps réel.

#### Environnement Dev avec Bind Mount
Créer un sous dossier avec à l'intérieur les fichiers souhaité. Bind ce dossier là pour éviter d'écraser le dossier racine créé depuis le Dockerfile. En l'occurence node_modules ne sera plus dans le dossier app, car écrasé à cause du **Bind Mount**.