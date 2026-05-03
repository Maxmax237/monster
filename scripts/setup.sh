#!/bin/bash
# ============================================
# Script d'initialisation du projet
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🏠 MenagePro - Setup${NC}"
echo "================================"

# 1. Vérifier que .env existe
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    echo -e "${YELLOW}⚠️  Fichier .env non trouvé${NC}"
    echo -e "   Création depuis .env.example..."
    cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
    echo -e "${GREEN}✅ .env créé${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANT:${NC} Éditez .env avec vos identifiants Supabase:"
    echo "   nano $PROJECT_ROOT/.env"
    echo ""
else
    echo -e "${GREEN}✅ .env existe déjà${NC}"
fi

# 2. Créer les répertoires nécessaires
mkdir -p "$PROJECT_ROOT/js"
mkdir -p "$PROJECT_ROOT/scripts"

# 3. Vérifier les modules JS
REQUIRED_FILES=("config.js" "supabase-client.js" "auth.js" "env-injected.js")
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$PROJECT_ROOT/js/$file" ]; then
        echo -e "${GREEN}✅ js/$file${NC}"
    else
        echo -e "${RED}❌ js/$file manquant${NC}"
    fi
done

# 4. Rendre les scripts exécutables
chmod +x "$PROJECT_ROOT/scripts/inject-env.sh"
chmod +x "$PROJECT_ROOT/scripts/setup.sh"
echo -e "${GREEN}✅ Scripts rendus exécutables${NC}"

# 5. Vérifier git
cd "$PROJECT_ROOT"
if [ -d .git ]; then
    echo -e "${GREEN}✅ Repository Git initialisé${NC}"
    
    # Vérifier que .env est dans .gitignore
    if grep -q "^.env$" .gitignore 2>/dev/null; then
        echo -e "${GREEN}✅ .env protégé par .gitignore${NC}"
    else
        echo ".env" >> .gitignore
        echo -e "${GREEN}✅ .env ajouté à .gitignore${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Git non initialisé${NC}"
    echo "   git init"
fi

echo ""
echo -e "${GREEN}🚀 Setup terminé !${NC}"
echo ""
echo "Prochaines étapes:"
echo "  1. Configurez .env avec vos identifiants Supabase"
echo "  2. Exécutez: ./scripts/inject-env.sh dev"
echo "  3. Lancez un serveur local: python3 -m http.server 8000"
