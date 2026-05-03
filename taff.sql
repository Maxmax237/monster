-- Table des candidates (femmes de ménage)
CREATE TABLE candidates (
    id BIGINT PRIMARY KEY,
    nom TEXT,
    email TEXT UNIQUE,
    password TEXT,
    telephone TEXT,
    age INT,
    ville TEXT,
    competences TEXT,
    experience FLOAT,
    latitude FLOAT,
    longitude FLOAT,
    address_detail TEXT,
    payment_method TEXT,
    payment_number TEXT,
    whatsapp TEXT,
    sms TEXT,
    email_notif TEXT,
    status TEXT,
    date_inscription TIMESTAMP
);

-- Table des propriétaires
CREATE TABLE owners (
    id BIGINT PRIMARY KEY,
    nom TEXT,
    email TEXT UNIQUE,
    password TEXT,
    telephone TEXT,
    ville TEXT,
    description TEXT,
    services TEXT,
    latitude FLOAT,
    longitude FLOAT,
    address_detail TEXT,
    whatsapp TEXT,
    sms TEXT,
    email_notif TEXT,
    status TEXT,
    date_inscription TIMESTAMP
);

-- Table des matchs/demandes
CREATE TABLE matches (
    id BIGINT PRIMARY KEY,
    owner_id BIGINT,
    candidate_id BIGINT,
    owner_name TEXT,
    candidate_name TEXT,
    distance FLOAT,
    status TEXT,
    created_at TIMESTAMP
);

-- Table des notations (ratings 1-10)
CREATE TABLE ratings (
    id BIGINT PRIMARY KEY,
    rater_id BIGINT,
    rater_type TEXT,
    target_id BIGINT,
    target_type TEXT,
    rating INT CHECK (rating >= 1 AND rating <= 10),
    created_at TIMESTAMP
);

-- Table des avis/commentaires (style Play Store)
CREATE TABLE reviews (
    id BIGINT PRIMARY KEY,
    rater_id BIGINT,
    rater_type TEXT,
    target_id BIGINT,
    target_type TEXT,
    rating INT CHECK (rating >= 1 AND rating <= 10),
    comment TEXT,
    task_type TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP
);

-- Table des catégories de services/tâches
CREATE TABLE service_categories (
    id BIGINT PRIMARY KEY,
    name TEXT,
    icon TEXT,
    description TEXT,
    color TEXT,
    created_at TIMESTAMP
);

-- Table des compétences spécifiques liées aux catégories
CREATE TABLE candidate_skills (
    id BIGINT PRIMARY KEY,
    candidate_id BIGINT,
    category_id BIGINT,
    skill_level INT CHECK (skill_level >= 1 AND skill_level <= 5),
    description TEXT,
    created_at TIMESTAMP
);

-- Ajouter colonne rating aux tables existantes
ALTER TABLE candidates ADD COLUMN IF NOT EXISTS rating INT DEFAULT 0;
ALTER TABLE candidates ADD COLUMN IF NOT EXISTS total_reviews INT DEFAULT 0;
ALTER TABLE owners ADD COLUMN IF NOT EXISTS rating INT DEFAULT 0;
ALTER TABLE owners ADD COLUMN IF NOT EXISTS total_reviews INT DEFAULT 0;

-- Insérer les catégories de services par défaut
INSERT INTO service_categories (id, name, icon, description, color) VALUES
(1, 'Ménage', '🧹', 'Nettoyage de maison, appartement, bureau', '#4A90E2'),
(2, 'Jardinage', '🌿', 'Tonte de pelouse, taille de haies, entretien jardin', '#7ED321'),
(3, 'Cuisine', '👨‍🍳', 'Préparation repas, événements, mariages, deuils', '#F5A623'),
(4, 'Lavage', '🧺', 'Lavage de linge, repassage, nettoyage à sec', '#BD10E0'),
(5, 'Garde d''enfants', '👶', 'Babysitting, accompagnement, aide aux devoirs', '#9013FE'),
(6, 'Bricolage', '🔧', 'Petites réparations, montage meubles, fixation', '#D0021B'),
(7, 'Courses', '🛒', 'Faire les courses, livraison de courses', '#50E3C2'),
(8, 'Déménagement', '📦', 'Aide au déménagement, transport', '#B8E986');

-- Index pour optimiser les recherches
CREATE INDEX idx_reviews_target ON reviews(target_id, target_type);
CREATE INDEX idx_reviews_rater ON reviews(rater_id, rater_type);
CREATE INDEX idx_reviews_status ON reviews(status);
CREATE INDEX idx_candidate_skills ON candidate_skills(candidate_id, category_id);
CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_candidates_status ON candidates(status);
CREATE INDEX idx_owners_status ON owners(status);
