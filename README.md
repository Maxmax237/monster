# MenagePro - Système de Services de Ménage

Application de marketplace pour services de ménage au Cameroun (Douala & Yaoundé).

## Architecture

| Composant | Technologie |
|-----------|-------------|
| Frontend | HTML5/CSS3/JavaScript vanilla |
| Backend/BDD | Supabase (PostgreSQL + Auth) |
| Notifications | WhatsApp API, Email, SMS |
| Géolocalisation | Navigator Geolocation API |

## Structure du Projet

```
monster/
├── index.html              # Application principale
├── js/
│   ├── env-injected.js     # Variables d'environnement (généré)
│   ├── config.js           # Configuration centralisée
│   ├── supabase-client.js  # Client Supabase initialisé
│   └── auth.js             # Module d'authentification sécurisé
├── scripts/
│   └── inject-env.sh       # Script d'injection ENV
├── .github/workflows/
│   └── deploy.yml          # CI/CD GitHub Actions
├── .env.example            # Template de configuration
└── taff.sql                # Schéma de base de données
```

## Configuration

### 1. Initialisation

```bash
# Copier le fichier de configuration
cp .env.example .env

# Éditer .env avec vos identifiants Supabase
nano .env
```

### 2. Variables Requises

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key-here
ADMIN_EMAIL=admin@menagepro.com
ADMIN_PASSWORD=change-this-strong-password
```

### 3. Injection des Variables

```bash
# Développement local
./scripts/inject-env.sh dev

# Test/Staging
./scripts/inject-env.sh test

# Production
./scripts/inject-env.sh prod
```

## Environnements

### Développement (dev)
- URL: `http://localhost`
- Supabase: Projet local ou distant
- Debug: Activé
- Logs: Console

### Test (test)
- URL: `https://staging.menagepro.com`
- Supabase: Projet de test dédié
- Debug: Activé
- Logs: Console + Sentry

### Production (prod)
- URL: `https://menagepro.com`
- Supabase: Projet production
- Debug: Désactivé
- Logs: Sentry uniquement

## Déploiement CI/CD

Le projet utilise GitHub Actions pour le déploiement automatique:

- **Branch `develop`** → Déploiement automatique sur Staging
- **Branch `main`** → Déploiement automatique sur Production

### Secrets GitHub Requis

```
STAGING_SUPABASE_URL
STAGING_SUPABASE_ANON_KEY
STAGING_ADMIN_EMAIL
STAGING_ADMIN_PASSWORD
PROD_SUPABASE_URL
PROD_SUPABASE_ANON_KEY
PROD_ADMIN_EMAIL
PROD_ADMIN_PASSWORD
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID_STAGING
VERCEL_PROJECT_ID_PROD
```

## Sécurité

### Changements Implémentés

1. ✅ **Credentials externalisés**: Supabase URL/Key dans `.env`
2. ✅ **Auth sécurisée**: Module AUTH avec session tokens
3. ✅ **Pas de credentials en dur**: Suppression des valeurs hardcodées
4. ✅ **.gitignore**: Protection contre le commit accidentel de `.env`

### Recommandations Supplémentaires

1. **Row Level Security (RLS)**: Activer sur toutes les tables Supabase
2. **Supabase Auth**: Migrer vers le système d'authentification natif
3. **Password Hashing**: Implémenter bcrypt côté serveur
4. **HTTPS**: Forcer HTTPS en production
5. **CSP Headers**: Ajouter Content-Security-Policy

## Schéma de Base de Données

### Tables Principales

- **`candidates`**: Profils des femmes de ménage
- **`owners`**: Profils des propriétaires/clients
- **`matches/requests`**: Demandes de mise en relation

### Relations

```
candidates (1) ←── (N) requests (N) ──→ (1) owners
```

## Scripts Utiles

```bash
# Injection ENV
./scripts/inject-env.sh [dev|test|prod]

# Déploiement manuel Vercel
vercel --prod

# Test local
python3 -m http.server 8000
# ou
npx serve .
```

## License

MIT License - voir `LICENSE`
