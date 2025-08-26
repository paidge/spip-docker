# Boilerplate SPIP avec docker-compose

## 1. Cloner le projet

`git clone https://github.com/paidge/spip-docker`

## 2. Lancez l'installation (nouveau dépôt git et variables d'environnement)

`cd spip-docker && ./install.sh`

## 3. Installer les plugins en tant que submodules et développer ses squelettes

`git submodule add <url_depot_plugin> plugins/<nom_plugin>`

## 4. Mettre à jour le nouveau dépôt

`git commit && git push`

## 5. Récupérer le projet en production

`git clone --recursive <url_du_nouveau_depot>`

## 8. Sauvegarde de la BDD

`docker exec <mon_projet>-mysql-1 mariadb-dump -u spip -pspip spip > backup.sql`

## 9. Restauration de la BDD

`docker exec <mon_projet>-mysql-1 mariadb -u spip -pspip spip < backup.sql`

**Remerciements :** Le présent dépôt utilise [l'image Docker de SPIP créée par IPEOS](https://github.com/ipeos-and-co/docker-spip)
