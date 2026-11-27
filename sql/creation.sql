-- Creation des tables de la base de donnees MiPlan
CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    pseudo VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mot_de_passe_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL
);
-- Table categorie
CREATE TABLE categorie (
    id_categorie SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);
-- Table ingredient
CREATE TABLE ingredient (
    id_ingredient SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);
-- Table recette
CREATE TABLE recette (
    id_recette SERIAL PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    temps_preparation INTEGER NOT NULL,
    portions_reference INTEGER NOT NULL,
    etapes_preparation TEXT NOT NULL,
    statut VARCHAR(30) NOT NULL,
    id_categorie INTEGER NOT NULL,
    id_createur INTEGER,
    id_moderateur INTEGER,
    decision VARCHAR(50),
    date_decision DATE,
    FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie),
    FOREIGN KEY (id_createur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (id_moderateur) REFERENCES utilisateur(id_utilisateur),
    CHECK (temps_preparation > 0),
    CHECK (portions_reference > 0)
);
-- Table planning
CREATE TABLE planning (
    id_planning SERIAL PRIMARY KEY,
    debut_semaine DATE NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    UNIQUE (id_utilisateur, debut_semaine)
);
-- Table repas planifie
CREATE TABLE repas_planifie (
    id_repas SERIAL PRIMARY KEY,
    date_repas DATE NOT NULL,
    creneau VARCHAR(10) NOT NULL,
    portions_choisies INTEGER NOT NULL,
    id_planning INTEGER NOT NULL,
    id_recette INTEGER NOT NULL,
    FOREIGN KEY (id_planning) REFERENCES planning(id_planning),
    FOREIGN KEY (id_recette) REFERENCES recette(id_recette),
    CHECK (creneau IN ('midi', 'soir')),
    CHECK (portions_choisies > 0),
    UNIQUE (id_planning, date_repas, creneau)
);
-- Table liste de courses
CREATE TABLE liste_courses (
    id_liste SERIAL PRIMARY KEY,
    date_generation DATE NOT NULL,
    id_planning INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (id_planning) REFERENCES planning(id_planning)
);
-- Table ligne de courses
CREATE TABLE ligne_courses (
    id_ligne SERIAL PRIMARY KEY,
    quantite NUMERIC NOT NULL,
    unite VARCHAR(20) NOT NULL,
    coche BOOLEAN NOT NULL DEFAULT FALSE,
    id_liste INTEGER NOT NULL,
    id_ingredient INTEGER NOT NULL,
    FOREIGN KEY (id_liste) REFERENCES liste_courses(id_liste),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient),
    CHECK (quantite > 0),
    UNIQUE (id_liste, id_ingredient, unite)
);
-- Association composer
CREATE TABLE composer (
    id_recette INTEGER,
    id_ingredient INTEGER,
    quantite NUMERIC NOT NULL,
    unite VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_recette, id_ingredient),
    FOREIGN KEY (id_recette) REFERENCES recette(id_recette),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient),
    CHECK (quantite > 0)
);
-- Association aimer
CREATE TABLE aimer (
    id_utilisateur INTEGER,
    id_recette INTEGER,
    PRIMARY KEY (id_utilisateur, id_recette),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (id_recette) REFERENCES recette(id_recette)
);
-- Association mettre en favori
CREATE TABLE favori (
    id_utilisateur INTEGER,
    id_recette INTEGER,
    PRIMARY KEY (id_utilisateur, id_recette),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (id_recette) REFERENCES recette(id_recette)
);
