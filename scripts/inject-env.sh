#!/bin/bash
# ============================================
# Script d'injection des variables d'environnement
# dans les fichiers HTML/JS statiques
# ============================================

set -e

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Détection de l'environnement
ENV=${1:-"dev"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${YELLOW}🔧 MenagePro - Injection ENV [${ENV}]${NC}"

# Vérifier que .env existe
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    echo -e "${RED}❌ Fichier .env manquant${NC}"
    echo "   Copiez .env.example vers .env et configurez vos variables"
    exit 1
fi

# Charger les variables d'environnement
export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)

# Vérifier les variables requises
if [ -z "$SUPABASE_URL" ] || [ "$SUPABASE_URL" == "https://your-project-id.supabase.co" ]; then
    echo -e "${RED}❌ SUPABASE_URL non configurée dans .env${NC}"
    exit 1
fi

if [ -z "$SUPABASE_ANON_KEY" ] || [ "$SUPABASE_ANON_KEY" == "your-anon-public-key-here" ]; then
    echo -e "${RED}❌ SUPABASE_ANON_KEY non configurée dans .env${NC}"
    exit 1
fi

# Créer le fichier d'injection
ENV_JS="window.ENV = {
    SUPABASE_URL: '${SUPABASE_URL}',
    SUPABASE_ANON_KEY: '${SUPABASE_ANON_KEY}',
    API_ENDPOINT: '${API_ENDPOINT:-https://api.menagepro.com}',
    ADMIN_EMAIL: '${ADMIN_EMAIL:-admin@menagepro.com}',
    ADMIN_PASSWORD: '${ADMIN_PASSWORD}',
    ENV: '${ENV}'
};"

# Générer env-injected.js
ENV_FILE="$PROJECT_ROOT/js/env-injected.js"
echo "$ENV_JS" > "$ENV_FILE"

echo -e "${GREEN}✅ Variables injectées dans js/env-injected.js${NC}"

# Mettre à jour index.html pour inclure env-injected.js
HTML_FILE="$PROJECT_ROOT/index.html"
if [ -f "$HTML_FILE" ]; then
    # Vérifier si le script est déjà inclus
    if ! grep -q "env-injected.js" "$HTML_FILE"; then
        # Insérer après <head> ou avant les autres scripts
        sed -i 's|<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>|<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>\n    <script src="js/env-injected.js"></script>\n    <script src="js/config.js"></script>\n    <script src="js/supabase-client.js"></script>\n    <script src="js/auth.js"></script>|' "$HTML_FILE"
        echo -e "${GREEN}✅ Scripts modulaires ajoutés à index.html${NC}"
    fi
fi

echo -e "${GREEN}🚀 Build terminé pour l'environnement: ${ENV}${NC}"
