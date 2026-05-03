/**
 * Client Supabase initialisé avec gestion d'erreurs
 */

const SupabaseClient = {
    instance: null,

    init() {
        if (this.instance) return this.instance;

        try {
            const cfg = window.CONFIG.current;
            
            if (!cfg.supabaseUrl || cfg.supabaseUrl.includes('placeholder')) {
                throw new Error('Supabase URL non configurée');
            }

            if (!window.supabase) {
                throw new Error('Librairie Supabase non chargée');
            }

            this.instance = window.supabase.createClient(cfg.supabaseUrl, cfg.supabaseKey);
            window.supabaseClient = this.instance;
            
            CONFIG.log('info', '✅ Supabase initialisé:', cfg.supabaseUrl);
            return this.instance;
        } catch (err) {
            CONFIG.log('error', '❌ Erreur init Supabase:', err.message);
            this.showConfigAlert();
            return null;
        }
    },

    showConfigAlert() {
        const isDev = window.CONFIG.getEnv() === 'dev';
        const message = isDev 
            ? '⚠️ Supabase non configuré (mode développement)\n\n1. Copiez .env.example vers .env\n2. Configurez vos identifiants Supabase\n3. Lancez ./scripts/inject-env.sh'
            : '⚠️ Erreur de connexion au serveur\n\nVeuillez réessayer ultérieurement.';
        
        // Afficher de manière non-intrusive en production
        if (isDev) {
            console.warn(message);
        }
    },

    isReady() {
        return this.instance !== null;
    }
};

window.SupabaseClient = SupabaseClient;
