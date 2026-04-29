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
