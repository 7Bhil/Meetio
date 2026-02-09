#!/usr/bin/env bash

# Dossier d'installation de Flutter
FLUTTER_PATH="$HOME/flutter"

# Cloner Flutter si il n'existe pas
if [ ! -d "$FLUTTER_PATH" ]; then
    echo "📥 Téléchargement du SDK Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_PATH"
fi

# Ajouter Flutter au PATH
export PATH="$PATH:$FLUTTER_PATH/bin"

# Désactiver les analytics pour gagner du temps
flutter config --no-analytics

# Télécharger les outils de build web
flutter precache --web

# Créer le fichier .env à la volée (pour Netlify)
echo "API_BASE_URL=$API_BASE_URL" > .env

# Builder le projet
echo "🏗️ Début du build Flutter Web..."
flutter build web --release
