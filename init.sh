#!/bin/bash

# Vérifier que git est installé
if ! command -v git &> /dev/null; then
    echo "❌ git n'est pas installé. Veuillez l'installer et réessayer."
    exit 1
fi

# Vérifier que docker-compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose n'est pas installé. Veuillez l'installer et réessayer."
    exit 1
fi

# Supprimer le dépôt git
if [ -d ".git" ]; then
    echo "🗑 Suppression de l'ancien dépôt git..."
    rm -rf .git
fi

# Demander si on veut ajouter un nouveau dépôt git
echo "⚙️ Voulez-vous versionner votre projet avec git ? (o/n)"
read -r REPONSE

if [[ "$REPONSE" =~ ^[Oo]$ ]]; then
    while true; do
        read -p "Quelle est l'URL du nouveau dépôt git ? " URL_NOUVEAU_DEPOT

        if [[ "$URL_NOUVEAU_DEPOT" =~ ^(https://.*\.git|git@.*:.*\.git)$ ]]; then
            echo "🔄 Initialisation d'un nouveau dépôt git..."
            git init
            git remote add origin "$URL_NOUVEAU_DEPOT"
            git add .
            break
        else
            echo "❌ L'URL fournie n'est pas valide. Elle doit ressembler à :"
            echo "   - https://exemple.com/mon-projet.git"
            echo "   - git@exemple.com:mon-projet.git"
            echo "Veuillez réessayer."
        fi
    done
fi

SPIP_SITE_ADDRESS=http://localhost:8880

echo "⚙️ Voulez-vous personnaliser les variables d'environnement ? (o/n)"
read -r REPONSE

if [[ "$REPONSE" =~ ^[Oo]$ ]]; then
    echo "🗑 Suppression de l'ancien fichier .env..."
    rm -f .env

    echo "✍️  Configuration du nouveau fichier .env"

    read -p "MYSQL_ROOT_PASSWORD [MysqlRootPassword]: " MYSQL_ROOT_PASSWORD
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-MysqlRootPassword}

    read -p "MYSQL_DATABASE [spipdb]: " MYSQL_DATABASE
    MYSQL_DATABASE=${MYSQL_DATABASE:-spipdb}

    read -p "MYSQL_USER [spipuser]: " MYSQL_USER
    MYSQL_USER=${MYSQL_USER:-spipuser}

    read -p "MYSQL_PASSWORD [spippw]: " MYSQL_PASSWORD
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-spippw}

    read -p "SPIP_DB_NAME [spipdb]: " SPIP_DB_NAME
    SPIP_DB_NAME=${SPIP_DB_NAME:-spipdb}

    read -p "SPIP_DB_LOGIN [spipuser]: " SPIP_DB_LOGIN
    SPIP_DB_LOGIN=${SPIP_DB_LOGIN:-spipuser}

    read -p "SPIP_DB_PASS [spippw]: " SPIP_DB_PASS
    SPIP_DB_PASS=${SPIP_DB_PASS:-spippw}

    read -p "SPIP_DB_PREFIX [spipprefix]: " SPIP_DB_PREFIX
    SPIP_DB_PREFIX=${SPIP_DB_PREFIX:-spipprefix}

    read -p "SPIP_ADMIN_NAME [AdminName]: " SPIP_ADMIN_NAME
    SPIP_ADMIN_NAME=${SPIP_ADMIN_NAME:-AdminName}

    read -p "SPIP_ADMIN_LOGIN [adminLogin]: " SPIP_ADMIN_LOGIN
    SPIP_ADMIN_LOGIN=${SPIP_ADMIN_LOGIN:-adminLogin}

    read -p "SPIP_ADMIN_EMAIL [admin@spip]: " SPIP_ADMIN_EMAIL
    SPIP_ADMIN_EMAIL=${SPIP_ADMIN_EMAIL:-admin@spip}

    read -p "SPIP_ADMIN_PASS [adminpassword]: " SPIP_ADMIN_PASS
    SPIP_ADMIN_PASS=${SPIP_ADMIN_PASS:-adminpassword}

    # read -p "SPIP_SITE_ADDRESS [http://localhost:8880]: " SPIP_SITE_ADDRESS
    #SPIP_SITE_ADDRESS=${SPIP_SITE_ADDRESS:-http://localhost:8880}

    read -p "PHP_MAX_EXECUTION_TIME [60]: " PHP_MAX_EXECUTION_TIME
    PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME:-60}

    read -p "PHP_MEMORY_LIMIT [256M]: " PHP_MEMORY_LIMIT
    PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-256M}

    read -p "PHP_POST_MAX_SIZE [40M]: " PHP_POST_MAX_SIZE
    PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-40M}

    read -p "PHP_UPLOAD_MAX_FILESIZE [32M]: " PHP_UPLOAD_MAX_FILESIZE
    PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-32M}

    read -p "PHP_TIMEZONE [Europe/Paris]: " PHP_TIMEZONE
    PHP_TIMEZONE=${PHP_TIMEZONE:-Europe/Paris}

    # Génération du fichier .env
    cat > .env <<EOF
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
MYSQL_DATABASE=$MYSQL_DATABASE
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD

SPIP_DB_NAME=$SPIP_DB_NAME
SPIP_DB_LOGIN=$SPIP_DB_LOGIN
SPIP_DB_PASS=$SPIP_DB_PASS
SPIP_DB_PREFIX=$SPIP_DB_PREFIX

SPIP_ADMIN_NAME=$SPIP_ADMIN_NAME
SPIP_ADMIN_LOGIN=$SPIP_ADMIN_LOGIN
SPIP_ADMIN_EMAIL=$SPIP_ADMIN_EMAIL
SPIP_ADMIN_PASS=$SPIP_ADMIN_PASS

SPIP_SITE_ADDRESS=$SPIP_SITE_ADDRESS

PHP_MAX_EXECUTION_TIME=$PHP_MAX_EXECUTION_TIME
PHP_MEMORY_LIMIT=$PHP_MEMORY_LIMIT
PHP_POST_MAX_SIZE=$PHP_POST_MAX_SIZE
PHP_UPLOAD_MAX_FILESIZE=$PHP_UPLOAD_MAX_FILESIZE
PHP_TIMEZONE=$PHP_TIMEZONE
EOF

    echo "✅ Nouveau fichier .env généré."
else
    echo "ℹ️ Personnalisation ignorée, le fichier .env existant reste inchangé."
fi

# Vérifier que Docker est lancé
if ! docker info >/dev/null 2>&1; then
    echo "⚠️ Docker n'est pas encore démarré. Attente..."
    # Boucle d'attente (max 60 secondes)
    for i in {1..30}; do
        if docker info >/dev/null 2>&1; then
            echo "✅ Docker est démarré."
            break
        fi
        echo "⏳ Tentative $i/30..."
        sleep 2
    done
fi

# Si Docker n'est toujours pas dispo après la boucle
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker ne semble pas démarré après 60s. Abandon."
    exit 1
fi

echo "🚀 Lancement de docker-compose"
docker-compose up -d || {
    echo "❌ Échec du lancement de docker-compose."
    exit 1
}

echo "🚀 Votre site est accessible sur $SPIP_SITE_ADDRESS"