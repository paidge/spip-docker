Dossier qui accueillera les plugins installés

**- Recommandation d'installation :**

Ne pas installer les plugins via l'interface d'administration. Mais en tant que submodule git :

`git submodule add <url_depot_plugin> plugins/<nom_plugin>`

**- Mise à jour des plugins :**

`git submodule update --remote`

**- Récupération d'un projet en cours et de ses plugins :**

`git clone --recursive <url_du_projet>`
