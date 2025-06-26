-- Création du schéma
CREATE SCHEMA IF NOT EXISTS tilt_schema;

-- Table utilisateur
CREATE TABLE tilt_schema.utilisateur (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    numero_telephone VARCHAR(20),
    adresse VARCHAR(255),
    code_postal VARCHAR(10),
    ville VARCHAR(100),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    code_secret VARCHAR(255),
    type_utilisateur VARCHAR(20) CHECK (type_utilisateur IN ('admin','client', 'commerçant')),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_utilisateur_email ON tilt_schema.utilisateur(email);

-- Table categorie
CREATE TABLE tilt_schema.categorie (
    id UUID PRIMARY KEY,
    nom_categorie VARCHAR(50) NOT NULL
);

CREATE INDEX idx_categorie_nom ON tilt_schema.categorie(nom_categorie);

-- Table magasin
CREATE TABLE tilt_schema.magasin (
    id UUID PRIMARY KEY,
    nom VARCHAR(100),
    numeros_de_siret VARCHAR(20) UNIQUE,
    numero_telephone VARCHAR(20),
    email VARCHAR(255) UNIQUE,
    site_web VARCHAR(255),
    description TEXT,
    adresse VARCHAR(255),
    code_postal VARCHAR(10),
    ville VARCHAR(100),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    photo_url VARCHAR(255),
    horaires_ouverture TEXT,
    id_categorie UUID REFERENCES tilt_schema.categorie(id),
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_magasin_categorie ON tilt_schema.magasin(id_categorie);
CREATE INDEX idx_magasin_utilisateur ON tilt_schema.magasin(id_utilisateur);
CREATE INDEX idx_magasin_ville ON tilt_schema.magasin(ville);

-- Table programme_fidelite
CREATE TABLE tilt_schema.programme_fidelite (
    id UUID PRIMARY KEY,
    id_magasin UUID REFERENCES tilt_schema.magasin(id),
    points_par_euro FLOAT DEFAULT 10.0,
    palier_points INTEGER,
    type_recompense VARCHAR(20) CHECK (type_recompense IN ('montant_fixe', 'pourcentage', 'objet')),
    valeur_recompense VARCHAR(100),
    description_recompense TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_programme_magasin ON tilt_schema.programme_fidelite(id_magasin);

-- Table achats
CREATE TABLE tilt_schema.achat (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    id_magasin UUID REFERENCES tilt_schema.magasin(id),
    montant DOUBLE PRECISION,
    points_gagnes DOUBLE PRECISION,
    date_achat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_achat_utilisateur ON tilt_schema.achat(id_utilisateur);
CREATE INDEX idx_achat_magasin ON tilt_schema.achat(id_magasin);
CREATE INDEX idx_achat_date ON tilt_schema.achat(date_achat);

-- Table recompense
CREATE TABLE tilt_schema.recompense (
    id UUID PRIMARY KEY,
    id_magasin UUID REFERENCES tilt_schema.magasin(id),
    points_requis DOUBLE PRECISION,
    type_recompense VARCHAR(20) CHECK (type_recompense IN ('montant_fixe', 'pourcentage', 'objet')),
    valeur_recompense VARCHAR(100),
    description_recompense TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_recompense_magasin ON tilt_schema.recompense(id_magasin);

-- Table point_client
CREATE TABLE tilt_schema.point_client (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    id_magasin UUID REFERENCES tilt_schema.magasin(id),
    solde_points DOUBLE PRECISION,
    points_utilises DOUBLE PRECISION,
    date_mise_a_jour TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX uniq_point_client ON tilt_schema.point_client(id_utilisateur, id_magasin);

-- Table recompense_utilisee
CREATE TABLE tilt_schema.recompense_utilisee (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    id_recompense UUID REFERENCES tilt_schema.recompense(id),
    id_magasin UUID REFERENCES tilt_schema.magasin(id),
    date_utilisation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_recompense_utilisee_utilisateur ON tilt_schema.recompense_utilisee(id_utilisateur);
CREATE INDEX idx_recompense_utilisee_recompense ON tilt_schema.recompense_utilisee(id_recompense);

-- Table abonnement
CREATE TABLE tilt_schema.abonnement (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    date_debut TIMESTAMP,
    date_fin TIMESTAMP,
    statut VARCHAR(20) CHECK (statut IN ('essai', 'actif', 'expiré', 'annulé')),
    type_abonnement VARCHAR(20) CHECK (type_abonnement IN ('mensuel', 'annuel')),
    type_abonnement_detail VARCHAR(20) CHECK (type_abonnement_detail IN ('basique', 'premium')),
    montant DOUBLE PRECISION,
    stripe_customer_id VARCHAR(255),
    stripe_subscription_id VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_abonnement_utilisateur ON tilt_schema.abonnement(id_utilisateur);

-- Table badge
CREATE TABLE tilt_schema.badge (
    id UUID PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    icone_url VARCHAR(255)
);

-- Table utilisateurs_badges
CREATE TABLE tilt_schema.utilisateurs_badges (
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    id_badge UUID REFERENCES tilt_schema.badge(id),
    date_obtention TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_utilisateur, id_badge)
);

-- Table parrainages
CREATE TABLE tilt_schema.parrainages (
    id UUID PRIMARY KEY,
    parrain_id UUID REFERENCES tilt_schema.utilisateur(id),
    filleul_id UUID REFERENCES tilt_schema.utilisateur(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    points_gagnes DOUBLE PRECISION
);

CREATE INDEX idx_parrainages_parrain ON tilt_schema.parrainages(parrain_id);
CREATE INDEX idx_parrainages_filleul ON tilt_schema.parrainages(filleul_id);

-- Table qr_code
CREATE TABLE tilt_schema.qr_code (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    code VARCHAR(255) UNIQUE,
    date_generation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actif BOOLEAN DEFAULT TRUE
    --ajouter une contrainte UNIQUE (id_utilisateur, actif) pour qu’un utilisateur ne puisse pas avoir plusieurs QR codes actifs
    CONSTRAINT unique_qr_code_actif UNIQUE (id_utilisateur, actif)
);

-- Table transaction_paiement
CREATE TABLE tilt_schema.transaction_paiement (
    id UUID PRIMARY KEY,
    id_abonnement UUID REFERENCES tilt_schema.abonnement(id),
    stripe_payment_intent_id VARCHAR(255),
    montant DOUBLE PRECISION,
    devise VARCHAR(10) DEFAULT 'EUR',
    statut VARCHAR(20) CHECK (statut IN ('succeeded', 'pending', 'failed')),
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table notifications
CREATE TABLE tilt_schema.notification (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    titre VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lu BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_notification_utilisateur ON tilt_schema.notification(id_utilisateur);
CREATE INDEX idx_notification_lu ON tilt_schema.notification(lu);

-- Table avis
CREATE TABLE tilt_schema.avis (
    id UUID PRIMARY KEY,
    id_utilisateur UUID REFERENCES tilt_schema.utilisateur(id),
    id_magasin UUID REFERENCES tilt_schema.magasin(id),
    note INTEGER CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    date_avis TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_avis_magasin ON tilt_schema.avis(id_magasin);
CREATE INDEX idx_avis_utilisateur ON tilt_schema.avis(id_utilisateur);
CREATE INDEX idx_avis_note ON tilt_schema.avis(note);
