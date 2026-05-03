/**
 * Configuration centralisée - MenagePro
 * Gestion des environnements : prod, test, dev
 */

const CONFIG = {
    // Détection automatique de l'environnement
    getEnv() {
        const hostname = window.location.hostname;
        if (hostname === 'localhost' || hostname === '127.0.0.1') return 'dev';
        if (hostname.includes('staging') || hostname.includes('test')) return 'test';
        return 'prod';
    },

    // Configuration par environnement
    environments: {
        dev: {
            supabaseUrl: window.ENV?.SUPABASE_URL || 'http://localhost:54321',
            supabaseKey: window.ENV?.SUPABASE_ANON_KEY || 'dev-key-placeholder',
            apiEndpoint: window.ENV?.API_ENDPOINT || 'http://localhost:3000',
            debug: true,
            logLevel: 'debug'
        },
        test: {
            supabaseUrl: window.ENV?.SUPABASE_URL || 'https://test-project.supabase.co',
            supabaseKey: window.ENV?.SUPABASE_ANON_KEY || 'test-key-placeholder',
            apiEndpoint: window.ENV?.API_ENDPOINT || 'https://api-staging.menagepro.com',
            debug: true,
            logLevel: 'info'
        },
        prod: {
            supabaseUrl: window.ENV?.SUPABASE_URL,
            supabaseKey: window.ENV?.SUPABASE_ANON_KEY,
            apiEndpoint: window.ENV?.API_ENDPOINT || 'https://api.menagepro.com',
            debug: false,
            logLevel: 'error'
        }
    },

    // Getter pour la config actuelle
    get current() {
        const env = this.getEnv();
        return this.environments[env];
    },

    // Helper pour valider la configuration
    validate() {
        const cfg = this.current;
        const required = ['supabaseUrl', 'supabaseKey'];
        const missing = required.filter(key => !cfg[key] || cfg[key].includes('placeholder'));
        
        if (missing.length > 0) {
            console.error('❌ Configuration manquante:', missing);
            return false;
        }
        return true;
    },

    // Logging conditionnel
    log(level, ...args) {
        const levels = { debug: 0, info: 1, warn: 2, error: 3 };
        const currentLevel = levels[this.current.logLevel] || 1;
        if (levels[level] >= currentLevel) {
            console[level](`[MenagePro][${this.getEnv()}]`, ...args);
        }
    }
};

// Exporter pour utilisation globale
window.CONFIG = CONFIG;
