# Boilerplate SPIP avec docker-compose

Architecture Docker avec script d'initialisation d'un nouveau projet SPIP.

## 1. Développement de votre projet

### 1. Initialiser et lancer le projet

`git clone https://github.com/paidge/spip-docker && spip-docker/launch.sh`

Au premier lancement du script (fichier .env absent) :

- il vous demandera si vous souhaitez versionner votre projet avec git. Si oui, il supprimera le dossier `.git` et vous demandera l'url de votre nouveau dépôt et procèdera à l'initialisation.
- Ensuite, il vous demanderade personnaliser les variables d'environnement et lancera le docker-compose.

Lors des prochains lancements (fichier .env présent) :

- le script lancera le docker-compose

### 2. Installer les plugins en tant que submodules et développer ses squelettes

`git submodule add <url_depot_plugin> plugins/<nom_plugin>`

Ceci vous permettra de mettre à jour facilement vos plugins et d'éviter de surcharger votre nouveau dépôt git avec le code des plugins tout en versionnant vos squelettes.

## 2. Mise en production

### 1. Mettre à jour votre nouveau dépôt (si existant)

`git commit && git push`

### 2. Récupérer le projet en production

`git clone --recursive <url_du_depot> && cd <dossier> && docker-compose up -d`

## 3. Mise à jour de votre projet

### 1. Mise à jour de SPIP

1. Sauvegarder la base de données
2. Mettre à jour la version de l'image utilisée dans le docker-compose.yml
3. Redémarrer les containers : `docker-compose down && docker-compose up -d`

### 2. Mise à jour des plugins

`git submodule update --remote`

## 4. Sauvegarde et restauration de la base de données

### 1. Sauvegarde de la BDD

`docker exec <mon_projet>-mysql-1 mariadb-dump -u spip -pspip spip > backup.sql`

### 2. Restauration de la BDD

`docker exec <mon_projet>-mysql-1 mariadb -u spip -pspip spip < backup.sql`

_**Remerciements :** Le présent dépôt utilise [l'image Docker de SPIP créée par IPEOS](https://github.com/ipeos-and-co/docker-spip)_
