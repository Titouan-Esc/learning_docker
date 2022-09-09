# ? docker build --build-arg folder=/app --build-arg file=app.js -t node:test .



# Importer une image depuis Docker Hub
FROM alpine

# Exécuter une commande au début de l'image
RUN apk add --update nodejs

# Renseigne des informations méta sur notre image
LABEL  maintainer="Titouan"
LABEL version=1.0

# Créer des variables utilisable dans le DockerFile
ARG folder
ARG file

# Créer des variables mais l'ajout aussi dans le container
ENV environnement =production

# Copie le fichier à la racine du dossier dans le conteneur
COPY ${file} ${folder}/

# Exécute une commande qui ne peut être écrasé
#ENTRYPOINT [ "echo", "First" ]

# Dire quand quel dossier on ce situe
WORKDIR ${folder}

# Exécute une commande qui peut être écrasé lors du run du container
CMD ["node", "app.js"]