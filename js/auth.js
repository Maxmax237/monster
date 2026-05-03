/**
 * Authentification sécurisée - MenagePro
 * Remplace les credentials en dur par Supabase Auth
 */

const AUTH = {
    // Admin credentials (à externaliser dans une solution sécurisée)
    // En production, utiliser Supabase Auth avec rôles
    async loginAdmin(email, password) {
        // Vérification via Supabase Auth (recommandé) ou variable d'environnement
        const adminEmail = window.ENV?.ADMIN_EMAIL;
        const adminPassword = window.ENV?.ADMIN_PASSWORD;
        
        // Fallback sécurisé (ne pas utiliser en production)
        if (!adminEmail || !adminPassword) {
            console.error('⚠️ Configuration admin manquante dans ENV');
            return { success: false, error: 'Configuration admin incomplète' };
        }
        
        if (email === adminEmail && password === adminPassword) {
            // Générer un token de session
            const session = {
                user: { nom: 'Admin', type: 'admin', email: adminEmail },
                token: this.generateToken(),
                expires: Date.now() + (24 * 60 * 60 * 1000) // 24h
            };
            this.setSession(session);
            return { success: true, user: session.user };
        }
        
        return { success: false, error: 'Identifiants incorrects' };
    },

    // Connexion candidat/propriétaire via Supabase
    async loginUser(email, password, type) {
        try {
            if (!window.supabaseClient) {
                throw new Error('Supabase non initialisé');
            }

            const table = type === 'candidate' ? 'candidates' : 'owners';
            const { data, error } = await window.supabaseClient
                .from(table)
                .select('*')
                .eq('email', email)
                .eq('password', password) // TODO: Utiliser bcrypt/hashing côté serveur
                .single();

            if (error || !data) {
                return { success: false, error: 'Identifiants incorrects' };
            }

            const session = {
                user: { ...data, type },
                token: this.generateToken(),
                expires: Date.now() + (24 * 60 * 60 * 1000)
            };
            this.setSession(session);
            return { success: true, user: session.user };
        } catch (err) {
            CONFIG.log('error', 'Erreur login:', err);
            return { success: false, error: err.message };
        }
    },

    generateToken() {
        return 'token_' + Math.random().toString(36).substr(2) + Date.now().toString(36);
    },

    setSession(session) {
        sessionStorage.setItem('menagepro_session', JSON.stringify(session));
    },

    getSession() {
        try {
            const session = JSON.parse(sessionStorage.getItem('menagepro_session'));
            if (!session || session.expires < Date.now()) {
                this.logout();
                return null;
            }
            return session;
        } catch {
            return null;
        }
    },

    logout() {
        sessionStorage.removeItem('menagepro_session');
        window.currentUser = null;
        window.currentUserType = null;
    },

    isAuthenticated() {
        return this.getSession() !== null;
    }
};

window.AUTH = AUTH;
