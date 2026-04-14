-- =============================================
-- BASE DE DONNEES : vdfi_mpihira
-- =============================================

CREATE DATABASE vdfi_mpihira;
\c vdfi_mpihira;

-- =============================================
-- 1. TABLES DE REFERENCE
-- =============================================

-- Table statut
CREATE TABLE statut (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50)
);

INSERT INTO statut (id_statut, libelle) VALUES
(1, 'Creee'),
(2, 'Validee'),
(3, 'Annulee'),
(4, 'Refusee');

-- Table etat
CREATE TABLE etat (
    id_etat SERIAL PRIMARY KEY,
    nom_etat VARCHAR(50),
    description TEXT
);

INSERT INTO etat (id_etat, nom_etat, description) VALUES
(1, 'Planifiee', 'Sortie en cours de preparation'),
(2, 'Confirmee', 'Reservation validee et confirmee'),
(3, 'Annulee', 'Sortie annulee'),
(4, 'Terminee', 'Evenement passe avec succes'),
(5, 'En cours', 'Evenement en cours de deroulement');

-- Table statut_envoi
CREATE TABLE statut_envoi (
    id_statut_envoi SERIAL PRIMARY KEY,
    nom_statut VARCHAR(50),
    description TEXT
);

INSERT INTO statut_envoi (id_statut_envoi, nom_statut, description) VALUES
(1, 'En attente', 'En attente d''envoi'),
(2, 'Envoye', 'Envoye avec succes'),
(3, 'Echec', 'Echec d''envoi'),
(4, 'Lu', 'Ouvert par le destinataire');

-- Table lieu
CREATE TABLE lieu (
    id_lieu SERIAL PRIMARY KEY,
    nom_lieu VARCHAR(100),
    adresse TEXT
);

CREATE INDEX idx_lieu_nom ON lieu(nom_lieu);

INSERT INTO lieu (id_lieu, nom_lieu, adresse) VALUES
(1,'METM Avaradoha', 'Avaradoha, Antananarivo'),
(2,'FPVM Talatanivolonondry', 'Talatanivolonondry, Antananarivo'),
(3,'FJKM Antanibe', 'Arivonimamo'),
(4,'FJKM Ziona Vaovao', 'Anatanambao, Imerintsiatosika'),
(5,'FJKM Ambavahadi Tokana', 'Itaosy, Antananarivo'),
(6,'Salle Spectacle EXO', 'Antsahamanitra, Antananarivo'),
(7,'FJKM Ikanja Fiderana', 'Antananarivo'),
(8,'FJKM Tranovato', 'Isoamanangano, Antananarivo'),
(9,'FPVM Ambohimahitsy', 'Ambohimahitsy, Antananarivo'),
(10,'FLM Ambatonjara', 'Bypass, Antananarivo'),
(11,'FJKM Ambatonakanga', 'Ambatonakanga, Antananarivo'),
(12,'FPVM Alarobia', 'Ambatomanga, Madagascar'),
(13,'METM Ambohidahy', 'Ankadidramamy, Antananarivo'),
(14,'Astaruiat', 'Antanimena, Antananarivo'),
(15,'FJKM Ziona Famonjena', 'Mamoladahy, Imerintsiatosika'),
(16,'FJKM Lazaina', 'Lazaina, Madagascar'),
(17,'Havoria', 'Anosy, Antananarivo'),
(18,'FPVM Soavimasoandro', 'Soavimasoandro, Madagascar'),
(19,'FJKM Ambohimandroso', 'Ambohimandroso, Antananarivo'),
(20,'FPVM Ambohimanarina', 'Ambohimanarina, Antananarivo');

-- =============================================
-- 2. ENTITES PRINCIPALES
-- =============================================

-- Table utilisateur
CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    role VARCHAR(10) CHECK (role IN ('admin','membre')),
    telephone VARCHAR(20),
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_utilisateur_email ON utilisateur(email);

INSERT INTO utilisateur (id_utilisateur, nom, prenom, email, mot_de_passe, role, telephone, date_inscription) VALUES
(1, 'ADMIN','admin', 'admin@gmail.com', 'admin1','admin', NULL, NULL),
(2, 'MEMBRE','membre','membre@gmail.com','membre1','membre', NULL, NULL);

-- Table membres
CREATE TABLE membres (
    id_membre SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    role VARCHAR(100),
    categorie VARCHAR(50) CHECK (categorie IN ('chef_de_choeur','responsable','auteur_compositeur','chanteur','chanteuse','musicien','musicienne','technicienne')),
    photo_path VARCHAR(255)
);

CREATE INDEX idx_membres_categorie ON membres(categorie);

INSERT INTO membres (id_membre, nom, prenom, role, categorie, photo_path) VALUES
(1,'Zoky','Vahatra', '1er Responsable','responsable','/photos/ZokyVahatra.jpg'),
(2,'Zoky','Holy', '1ere Responsable','responsable','/photos/ZokyHoly.jpg'),
(3,'RASOAMANANA', 'Mbolatiana Toky','Auteur-Compositeur','auteur_compositeur','/photos/Mbola.jpg'),
(4,'ANDRIAMANJATO', 'Lahatriniavo Fandresena','Chef de Choeur','chef_de_choeur','/photos/Fandresena.jpg'),
(5,'ANDINIRINAMALALA', 'Anjara Tinatia','Responsable medias','responsable','/photos/Tinatia.jpg'),
(6,'RAFIRINGANIRINA', 'Lovatiana Zo', '1ere voix','chanteuse','/photos/Zo.jpg'),
(7,'RAKOTOARISOA','Oniniaina','1ere voix','chanteuse','/photos/Oniniaina.jpg'),
(8,'RAKOTOMIHAJA','Tantanantsoa' ,'1ere voix','chanteuse','/photos/Tantanantsoa.jpg'),
(9,'RAKOTONANAHARY','Tsirava Finiavana', '1ere/2eme voix','chanteuse','/photos/Tsirava.jpg'),
(10,'RAHARINIRINA','Vonifanja Nathalie','2eme voix','chanteuse','/photos/Nathalie.jpg'),
(12,'ANDRIANTSIMANIRY','Iaritiana Famenontsoa','3eme voix','chanteur','/photos/Famenontsoa.jpg'),
(13,'RAKOTOMALALA','Fifaliana Mamilalaina',' 3eme voix','chanteur','/photos/Fifaliana.jpg'),
(14,'VAHATRINIAINA','Tiavo','3eme voix','chanteur','/photos/Tiavo.jpg'),
(15,'RALAIKOA','Falinirina Raphael Joseph','Clavieriste','musicien','/photos/Raphael.jpg'),
(16,'NOMENJANAHARY','Sitrakiniaina Erick','Clavieriste','musicien','/photos/Erick.jpg'),
(17,'RAZANADRAKOTO','Nirintsoa Heriniaina','Guitariste','musicien','/photos/Aina.jpg'),
(18,'LALAINAHARIJAONA','Anjara Toavina','Bassiste','musicien','/photos/Toavina.jpg'),
(19,'ANDRY NANTENAINA','Toky','Batteur','musicien','/photos/Toky.jpg'),
(20,'RASOAMANANA','Mitia Talenta','Violiniste','musicienne','/photos/Mitia.jpg');

-- Table chanson
CREATE TABLE chanson (
    id_chanson SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    paroles TEXT,
    auteur VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    date_creation DATE,
    partition_pdf VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_chanson_titre ON chanson(titre);
CREATE INDEX idx_chanson_genre ON chanson(genre);
CREATE INDEX idx_chanson_auteur ON chanson(auteur);
CREATE INDEX idx_chanson_date_creation ON chanson(date_creation);

-- Table photo
CREATE TABLE photo (
    id_photo SERIAL PRIMARY KEY,
    photo_path VARCHAR(255),
    legende TEXT,
    type_evenement VARCHAR(50),
    localisation VARCHAR(100),
    date_creation DATE
);

INSERT INTO photo (id_photo, photo_path, legende, type_evenement, localisation, date_creation) VALUES
(1, '/photos/metm_avaradoha.jpg', 'METM Avaradoha', 'sortie', 'Avaradoha', '2024-10-27'),
(2, '/photos/fpvm_talatanivolonondry.jpg', 'FPVM Talatanivolonondry', 'sortie', 'Talatanivolonondry', '2024-11-24'),
(3, '/photos/fjkm_antanibe_fiainana_arivonimamo.jpg', 'FJKM Antanibe Fiainana Arivonimamo', 'sortie', 'Arivonimamo', '2024-12-08'),
(4, '/photos/fjkm_ziona_vaovao_tsarahonenana_imerintsiatosika.jpg', 'FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika', 'sortie', 'Imerintsiatosika', '2025-04-06'),
(5, '/photos/fjkm_ambavahadi_tokana_itaosy.jpg', 'FJKM Ambavahadi Tokana Itaosy', 'sortie', 'Itaosy', '2025-04-27'),
(6, '/photos/exo_antsahamanitra.jpg', 'Spectacle EXO Antsahamanitra', 'sortie', 'Antsahamanitra', '2025-05-03'),
(7, '/photos/fjkm_ikanja_fiderana_arivonimamo.jpg', 'FJKM Ikanja Fiderana Arivonimamo', 'sortie', 'Arivonimamo', '2025-05-04'),
(8, '/photos/fjkm_tranovato_isoamanangano.jpg', 'FJKM Tranovato Isoamanangano', 'sortie', 'Isoamanangano', '2025-05-11'),
(9, '/photos/fjkm_antanibe_fiainana_arivonimamo.jpg', 'FJKM Antanibe Fiainana Arivonimamo', 'sortie', 'Arivonimamo', '2025-05-18'),
(10, '/photos/fpvm_ambohimahitsy.jpg', 'FPVM Ambohimahitsy', 'sortie', 'Ambohimahitsy', '2025-05-24'),
(11, '/photos/flm_ambatonjara_bypass.jpg', 'FLM Ambatonjara Bypass', 'sortie', 'Ambatonjara', '2025-06-22'),
(12, '/photos/fjkm_ambatonakanga.jpg', 'FJKM Ambatonakanga', 'sortie', 'Ambatonakanga', '2025-07-06'),
(13, '/photos/fpvm_alarobia_ambatomanga.jpg', 'FPVM Alarobia Ambatomanga', 'sortie', 'Ambatomanga', '2025-07-12'),
(14, '/photos/metm_ambohidahy_ankadidramamy.jpg', 'METM Ambohidahy Ankadidramamy', 'sortie', 'Ankadidramamy', '2025-07-20'),
(15, '/photos/astauriat_antanimena.jpg', 'Astauriat Antanimena', 'sortie', 'Antanimena', '2025-07-27'),
(16, '/photos/fjkm_ziona_famonjena_imerintsiatosika.jpg', 'FJKM Ziona Famonjena Imerintsiatosika', 'sortie', 'Imerintsiatosika', '2025-08-02'),
(17, '/photos/fjkm_lazaina.jpg', 'FJKM Lazaina', 'sortie', 'Lazaina', '2025-08-03'),
(18, '/photos/havoria_anosy.jpg', 'Havoria Anosy', 'sortie', 'Anosy', '2025-08-10'),
(19, '/photos/fpvm_soavimasoandro.jpg', 'FPVM Soavimasoandro', 'sortie', 'Soavimasoandro', '2025-08-24'),
(20, '/photos/fjkm_ambohimandroso_ambatondrazaka.jpg', 'FJKM Ambohimandroso Ambatondrazaka', 'sortie', 'Ambatondrazaka', '2025-08-31'),
(21, '/photos/fpvm_ambohimanarina.jpg', 'FPVM Ambohimanarina', 'sortie', 'Ambohimanarina', '2025-09-14'),
(22, '/photos/fpvm_carion.jpg', 'FPVM Carion', 'sortie', 'Carion', '2025-10-26'),
(23, '/photos/fpvm_carion2.jpg', 'FPVM Carion', 'sortie', 'Carion', '2025-11-09');

-- Table repertoire
CREATE TABLE repertoire (
    id_repertoire SERIAL PRIMARY KEY,
    date_preparation DATE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    titre VARCHAR(100)
);

CREATE INDEX idx_repertoire_date_preparation ON repertoire(date_preparation);
CREATE INDEX idx_repertoire_titre ON repertoire(titre);

INSERT INTO repertoire (date_preparation, titre, description) VALUES
('2024-10-27', 'METM Avaradoha', 'Preparation du repertoire pour METM Avaradoha.'),
('2024-11-24', 'FPVM Talatanivolonondry', 'Preparation du repertoire pour FPVM Talatanivolonondry.'),
('2024-12-08', 'FJKM Antanibe Fiainana Arivonimamo', 'Preparation du repertoire pour FJKM Antanibe Fiainana Arivonimamo.'),
('2025-04-06', 'FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika', 'Preparation du repertoire pour FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika.'),
('2025-04-27', 'FJKM Ambavahadi Tokana Itaosy', 'Preparation du repertoire pour FJKM Ambavahadi Tokana Itaosy.'),
('2025-05-03', 'Spectacle EXO Antsahamanitra', 'Preparation du repertoire pour Spectacle EXO Antsahamanitra.'),
('2025-05-04', 'FJKM Ikanja Fiderana Arivonimamo', 'Preparation du repertoire pour FJKM Ikanja Fiderana Arivonimamo.'),
('2025-05-11', 'FJKM Tranovato Isoamanangano', 'Preparation du repertoire pour FJKM Tranovato Isoamanangano.'),
('2025-05-18', 'FJKM Antanibe Fiainana Arivonimamo', 'Preparation du repertoire pour FJKM Antanibe Fiainana Arivonimamo.'),
('2025-05-24', 'FPVM Ambohimahitsy', 'Preparation du repertoire pour FPVM Ambohimahitsy.'),
('2025-06-22', 'FLM Ambatonjara Bypass', 'Preparation du repertoire pour FLM Ambatonjara Bypass.'),
('2025-07-06', 'FJKM Ambatonakanga', 'Preparation du repertoire pour FJKM Ambatonakanga.'),
('2025-07-12', 'FPVM Alarobia Ambatomanga', 'Preparation du repertoire pour FPVM Alarobia Ambatomanga.'),
('2025-07-20', 'METM Ambohidahy Ankadidramamy', 'Preparation du repertoire pour METM Ambohidahy Ankadidramamy.'),
('2025-07-27', 'Astauriat Antanimena', 'Preparation du repertoire pour Astauriat Antanimena.'),
('2025-08-02', 'FJKM Ziona Famonjena Imerintsiatosika', 'Preparation du repertoire pour FJKM Ziona Famonjena Imerintsiatosika.'),
('2025-08-03', 'FJKM Lazaina', 'Preparation du repertoire pour FJKM Lazaina.'),
('2025-08-10', 'Havoria Anosy', 'Preparation du repertoire pour Havoria Anosy.'),
('2025-08-24', 'FPVM Soavimasoandro', 'Preparation du repertoire pour FPVM Soavimasoandro.'),
('2025-08-31', 'FJKM Ambohimandroso Ambatondrazaka', 'Preparation du repertoire pour FJKM Ambohimandroso Ambatondrazaka.'),
('2025-09-14', 'FPVM Ambohimanarina', 'Preparation du repertoire pour FPVM Ambohimanarina.'),
('2025-10-26', 'FPVM Carion', 'Preparation du repertoire pour FPVM Carion.'),
('2025-11-09', 'FPVM Carion', 'Preparation du repertoire pour FPVM Carion.');

-- =============================================
-- 3. TABLES DEPENDANTES (avec cles etrangeres)
-- =============================================

-- Table media_chanson
CREATE TABLE media_chanson (
    id_media_chanson SERIAL PRIMARY KEY,
    id_chanson INTEGER REFERENCES chanson(id_chanson) ON DELETE CASCADE,
    type_media VARCHAR(50) CHECK (type_media IN ('audio','video_clip','lyrics','playback','partition_pdf','parole_powerpoint')),
    fichier_path VARCHAR(255),
    fichier_nom_original VARCHAR(255),
    taille_fichier INTEGER,
    format_fichier VARCHAR(10),
    duree TIME,
    url_externe VARCHAR(500),
    description TEXT,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_media_chanson_type ON media_chanson(type_media);

-- Table repertoire_chanson
CREATE TABLE repertoire_chanson (
    id_repertoire_chanson SERIAL PRIMARY KEY,
    id_repertoire INTEGER REFERENCES repertoire(id_repertoire) ON DELETE CASCADE,
    id_chanson INTEGER REFERENCES chanson(id_chanson) ON DELETE CASCADE,
    ordre_chanson INTEGER DEFAULT 0,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_repertoire, id_chanson)
);

CREATE INDEX idx_repertoire_chanson_ordre ON repertoire_chanson(ordre_chanson);

-- Table reservation
CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,
    id_utilisateur INTEGER REFERENCES utilisateur(id_utilisateur),
    nom_eglise VARCHAR(100),
    adresse_eglise TEXT,
    contact VARCHAR(100),
    email_contact VARCHAR(100),
    date_evenement DATE,
    periode_journee VARCHAR(50) CHECK (periode_journee IN ('matin','apres-midi','toute-la-journee')),
    description_reservation TEXT,
    sono_complet BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_statut INTEGER REFERENCES statut(id_statut),
    id_lieu INTEGER REFERENCES lieu(id_lieu)
);

CREATE INDEX idx_reservation_date ON reservation(date_evenement);

-- Table reservation_statut
CREATE TABLE reservation_statut (
    id_res_statut SERIAL PRIMARY KEY,
    id_reservation INTEGER REFERENCES reservation(id_reservation) ON DELETE CASCADE,
    id_statut INTEGER REFERENCES statut(id_statut),
    date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table sortie
CREATE TABLE sortie (
    id_sortie SERIAL PRIMARY KEY,
    id_reservation INTEGER NOT NULL REFERENCES reservation(id_reservation) ON DELETE CASCADE,
    id_lieu INTEGER NOT NULL REFERENCES lieu(id_lieu),
    id_etat INTEGER NOT NULL REFERENCES etat(id_etat),
    id_photo INTEGER REFERENCES photo(id_photo),
    date_sortie TIMESTAMP NOT NULL,
    description TEXT
);

CREATE INDEX idx_sortie_date ON sortie(date_sortie);

-- Table sortie_repertoire
CREATE TABLE sortie_repertoire (
    id_sortie_repertoire SERIAL PRIMARY KEY,
    id_sortie INTEGER REFERENCES sortie(id_sortie) ON DELETE CASCADE,
    id_repertoire INTEGER REFERENCES repertoire(id_repertoire) ON DELETE CASCADE,
    date_utilisation DATE,
    UNIQUE(id_sortie, id_repertoire)
);

-- Table sortie_membres
CREATE TABLE sortie_membres (
    id_sortie_membre SERIAL PRIMARY KEY,
    id_sortie INTEGER NOT NULL REFERENCES sortie(id_sortie) ON DELETE CASCADE,
    id_membre INTEGER NOT NULL REFERENCES membres(id_membre) ON DELETE CASCADE,
    role_dans_sortie VARCHAR(100),
    UNIQUE(id_sortie, id_membre)
);

-- Table sortie_etat
CREATE TABLE sortie_etat (
    id_sortie_etat SERIAL PRIMARY KEY,
    id_sortie INTEGER NOT NULL REFERENCES sortie(id_sortie) ON DELETE CASCADE,
    id_etat INTEGER NOT NULL REFERENCES etat(id_etat),
    date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table media_archive
CREATE TABLE media_archive (
    id_media SERIAL PRIMARY KEY,
    id_sortie INTEGER REFERENCES sortie(id_sortie) ON DELETE SET NULL,
    type_media VARCHAR(50) NOT NULL CHECK (type_media IN ('photo','video','affiche','document')),
    fichier_path VARCHAR(255) NOT NULL,
    fichier_nom_original VARCHAR(255),
    taille_fichier INTEGER,
    format_fichier VARCHAR(10),
    description TEXT,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ordre_affichage INTEGER DEFAULT 0,
    actif BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_media_archive_type ON media_archive(type_media);

-- Table photo_sortie
CREATE TABLE photo_sortie (
    id_photo_sortie SERIAL PRIMARY KEY,
    id_sortie INTEGER REFERENCES sortie(id_sortie),
    id_photo INTEGER REFERENCES photo(id_photo),
    date_sortie DATE
);

-- Table notification
CREATE TABLE notification (
    id_notification SERIAL PRIMARY KEY,
    id_reservation INTEGER REFERENCES reservation(id_reservation),
    id_sortie INTEGER REFERENCES sortie(id_sortie),
    destinataire VARCHAR(100),
    message TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type_notification VARCHAR(50),
    envoye BOOLEAN DEFAULT FALSE
);

-- Table notification_statut
CREATE TABLE notification_statut (
    id_notification_statut SERIAL PRIMARY KEY,
    id_notification INTEGER REFERENCES notification(id_notification) ON DELETE CASCADE,
    id_statut_envoi INTEGER REFERENCES statut_envoi(id_statut_envoi),
    date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table publication_facebook
CREATE TABLE publication_facebook (
    id_publication SERIAL PRIMARY KEY,
    id_sortie INTEGER REFERENCES sortie(id_sortie),
    message_poste TEXT,
    url_media VARCHAR(500),
    date_publication TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'programme' CHECK (statut IN ('programme','publie','echec')),
    message_erreur TEXT,
    id_post_facebook VARCHAR(100)
);

-- =============================================
-- 4. VUES UTILES
-- =============================================

CREATE VIEW vue_sorties_completes AS
SELECT
    s.id_sortie,
    s.date_sortie,
    s.description,
    r.nom_eglise,
    l.nom_lieu,
    e.nom_etat,
    string_agg(DISTINCT CONCAT(m.nom, ' ', m.prenom), ', ') AS membres
FROM sortie s
LEFT JOIN reservation r ON s.id_reservation = r.id_reservation
LEFT JOIN lieu l ON s.id_lieu = l.id_lieu
LEFT JOIN etat e ON s.id_etat = e.id_etat
LEFT JOIN sortie_membres sm ON s.id_sortie = sm.id_sortie
LEFT JOIN membres m ON sm.id_membre = m.id_membre
GROUP BY s.id_sortie, r.nom_eglise, l.nom_lieu, e.nom_etat;

-- =============================================
-- 5. VERIFICATION
-- =============================================

SELECT 'Base de donnees vdfi_mpihira creee avec succes!' AS status;






-- =============================================
-- INSERTIONS MANQUANTES
-- =============================================

-- 1. Insertion de chansons (table chanson)
INSERT INTO chanson (titre, paroles, auteur, genre, date_creation, partition_pdf) VALUES
('Fitiavana tsy mety maty', 'Paroles de la chanson...', 'RASOAMANANA Mbolatiana Toky', 'Gospel', '2024-01-15', '/partitions/fitiavana.pdf'),
('Masoandro velona', 'Paroles de la chanson...', 'RASOAMANANA Mbolatiana Toky', 'Adoration', '2024-02-20', '/partitions/masoandro.pdf'),
('Voninahitra ho Anao', 'Paroles de la chanson...', 'ANDRIAMANJATO Lahatriniavo', 'Louange', '2024-03-10', '/partitions/voninahitra.pdf'),
('Fiderana mandrakizay', 'Paroles de la chanson...', 'RASOAMANANA Mbolatiana Toky', 'Gospel', '2024-04-05', '/partitions/fiderana.pdf'),
('Ny finoako', 'Paroles de la chanson...', 'ANDRIAMANJATO Lahatriniavo', 'Adoration', '2024-05-12', '/partitions/finoako.pdf');

-- 2. Insertion de media_chanson
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, duree, description) VALUES
(1, 'audio', '/audios/fitiavana.mp3', 'fitiavana_tsisy_metty_maty.mp3', 5242880, 'mp3', '00:04:30', 'Version studio'),
(1, 'playback', '/playbacks/fitiavana_playback.mp3', 'fitiavana_playback.mp3', 5242880, 'mp3', '00:04:30', 'Playback pour répétition'),
(2, 'audio', '/audios/masoandro.mp3', 'masoandro_velona.mp3', 3670016, 'mp3', '00:03:45', 'Version live'),
(3, 'partition_pdf', '/partitions/voninahitra_scores.pdf', 'voninahitra_scores.pdf', 1048576, 'pdf', NULL, 'Partition complète'),
(4, 'video_clip', '/videos/fiderana.mp4', 'fiderana_clip.mp4', 52428800, 'mp4', '00:05:00', 'Clip vidéo officiel');

-- 3. Insertion de repertoire_chanson (liaison répertoire - chansons)
INSERT INTO repertoire_chanson (id_repertoire, id_chanson, ordre_chanson) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(2, 1, 1),
(2, 4, 2),
(2, 5, 3),
(3, 2, 1),
(3, 3, 2),
(3, 5, 3);

-- 4. Insertion de réservations
INSERT INTO reservation (id_utilisateur, nom_eglise, adresse_eglise, contact, email_contact, date_evenement, periode_journee, description_reservation, sono_complet, id_statut, id_lieu) VALUES
(2, 'FJKM Ambatonakanga', 'Ambatonakanga, Antananarivo', '0341234567', 'contact@ambatonakanga.mg', '2025-07-06', 'matin', 'Culte dominical avec chorale', true, 2, 11),
(2, 'FPVM Alarobia', 'Ambatomanga, Madagascar', '0342345678', 'secretariat@fpvm-alarobia.mg', '2025-07-12', 'apres-midi', 'Conférence évangélique', false, 2, 12),
(2, 'METM Ambohidahy', 'Ankadidramamy, Antananarivo', '0343456789', 'contact@metm.mg', '2025-07-20', 'toute-la-journee', 'Fête de la musique', true, 1, 13),
(2, 'Astauriat Antanimena', 'Antanimena, Antananarivo', '0344567890', 'info@astauriat.mg', '2025-07-27', 'soir', 'Concert de gospel', true, 2, 14);

-- 5. Insertion de sorties
INSERT INTO sortie (id_reservation, id_lieu, id_etat, id_photo, date_sortie, description) VALUES
(1, 11, 2, 12, '2025-07-06 08:00:00', 'Sortie à FJKM Ambatonakanga pour le culte dominical'),
(2, 12, 2, 13, '2025-07-12 14:00:00', 'Sortie à FPVM Alarobia pour la conférence'),
(3, 13, 1, 14, '2025-07-20 09:00:00', 'Sortie à METM Ambohidahy - en préparation'),
(4, 14, 2, 15, '2025-07-27 18:00:00', 'Sortie à Astauriat pour le concert');

-- 6. Insertion de sortie_membres (participation des membres aux sorties)
INSERT INTO sortie_membres (id_sortie, id_membre, role_dans_sortie) VALUES
(1, 4, 'Chef de chœur'),
(1, 6, 'Chanteuse 1ere voix'),
(1, 7, 'Chanteuse 1ere voix'),
(1, 10, 'Chanteuse 2eme voix'),
(1, 12, 'Chanteur 3eme voix'),
(1, 15, 'Claviériste'),
(1, 17, 'Guitariste'),
(2, 4, 'Chef de chœur'),
(2, 8, 'Chanteuse 1ere voix'),
(2, 9, 'Chanteuse 1ere/2eme voix'),
(2, 13, 'Chanteur 3eme voix'),
(2, 16, 'Claviériste'),
(2, 18, 'Bassiste'),
(3, 4, 'Chef de chœur'),
(3, 6, 'Chanteuse 1ere voix'),
(3, 10, 'Chanteuse 2eme voix'),
(3, 14, 'Chanteur 3eme voix'),
(3, 15, 'Claviériste'),
(3, 19, 'Batteur'),
(4, 4, 'Chef de chœur'),
(4, 7, 'Chanteuse 1ere voix'),
(4, 9, 'Chanteuse 1ere/2eme voix'),
(4, 12, 'Chanteur 3eme voix'),
(4, 16, 'Claviériste'),
(4, 20, 'Violiniste');

-- 7. Insertion de sortie_etat (historique des états des sorties)
INSERT INTO sortie_etat (id_sortie, id_etat, date_changement) VALUES
(1, 1, '2025-06-20 10:00:00'),
(1, 2, '2025-06-25 14:30:00'),
(2, 1, '2025-06-22 09:00:00'),
(2, 2, '2025-06-28 11:15:00'),
(3, 1, '2025-06-30 08:00:00'),
(4, 1, '2025-06-25 13:00:00'),
(4, 2, '2025-07-01 16:45:00');

-- 8. Insertion de sortie_repertoire
INSERT INTO sortie_repertoire (id_sortie, id_repertoire, date_utilisation) VALUES
(1, 11, '2025-07-06'),
(2, 12, '2025-07-12'),
(3, 13, '2025-07-20'),
(4, 14, '2025-07-27');

-- 9. Insertion de media_archive
INSERT INTO media_archive (id_sortie, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, description, ordre_affichage) VALUES
(1, 'photo', '/archives/sortie1/photo1.jpg', 'ambatonakanga_culte.jpg', 2097152, 'jpg', 'Photo du culte à Ambatonakanga', 1),
(1, 'video', '/archives/sortie1/video1.mp4', 'performance_chorale.mp4', 104857600, 'mp4', 'Vidéo de la performance', 2),
(2, 'affiche', '/archives/sortie2/affiche.pdf', 'affiche_conference.pdf', 524288, 'pdf', 'Affiche de la conférence', 1),
(4, 'photo', '/archives/sortie4/concert1.jpg', 'concert_astauriat.jpg', 3145728, 'jpg', 'Concert à Astauriat', 1);

-- 10. Insertion de photo_sortie
INSERT INTO photo_sortie (id_sortie, id_photo, date_sortie) VALUES
(1, 12, '2025-07-06'),
(2, 13, '2025-07-12'),
(3, 14, '2025-07-20'),
(4, 15, '2025-07-27');

-- 11. Insertion de notifications
INSERT INTO notification (id_reservation, id_sortie, destinataire, message, type_notification, envoye) VALUES
(1, 1, 'contact@ambatonakanga.mg', 'Votre réservation pour le 2025-07-06 a été confirmée', 'confirmation', true),
(2, 2, 'secretariat@fpvm-alarobia.mg', 'La sortie du 2025-07-12 est planifiée', 'planification', true),
(4, 4, 'info@astauriat.mg', 'Rappel: Concert prévu le 2025-07-27', 'rappel', false),
(3, 3, 'contact@metm.mg', 'Votre réservation est en cours de validation', 'validation', true);

-- 12. Insertion de notification_statut
INSERT INTO notification_statut (id_notification, id_statut_envoi, date_changement) VALUES
(1, 2, '2025-06-25 15:00:00'),
(2, 2, '2025-06-28 11:30:00'),
(3, 1, '2025-07-01 09:00:00'),
(4, 2, '2025-06-30 14:20:00');

-- 13. Insertion de publication_facebook
INSERT INTO publication_facebook (id_sortie, message_poste, url_media, date_publication, statut, id_post_facebook) VALUES
(1, 'Venez nombreux au culte à FJKM Ambatonakanga ce dimanche avec la chorale VDFI Mpihira !', '/images/ambatonakanga_promo.jpg', '2025-07-05 08:00:00', 'publie', 'fb_post_123456'),
(2, 'Conférence évangélique à FPVM Alarobia - Entrée libre', '/images/alarobia_promo.jpg', '2025-07-11 10:00:00', 'publie', 'fb_post_123457'),
(4, 'Concert de gospel ce soir à Astauriat Antanimena !', '/images/astauriat_promo.jpg', '2025-07-27 12:00:00', 'programme', NULL);

-- 14. Mise à jour des statuts de réservation
INSERT INTO reservation_statut (id_reservation, id_statut, date_changement) VALUES
(1, 1, '2025-06-15 09:00:00'),
(1, 2, '2025-06-20 14:00:00'),
(2, 1, '2025-06-18 10:30:00'),
(2, 2, '2025-06-22 16:00:00'),
(3, 1, '2025-06-25 11:00:00'),
(4, 1, '2025-06-20 08:00:00'),
(4, 2, '2025-06-28 15:30:00');

-- 15. Insertion de quelques chansons supplémentaires avec différents genres
INSERT INTO chanson (titre, paroles, auteur, genre, date_creation) VALUES
('Miandry Anao aho', 'Paroles...', 'RASOAMANANA Mbolatiana Toky', 'Adoration', '2024-06-01'),
('Hoby Anao ry Jesosy', 'Paroles...', 'ANDRIAMANJATO Lahatriniavo', 'Louange', '2024-07-15'),
('Famindrana tsy manam-petra', 'Paroles...', 'RASOAMANANA Mbolatiana Toky', 'Gospel', '2024-08-20'),
('Ny lalanao', 'Paroles...', 'ANDRIAMANJATO Lahatriniavo', 'Adoration', '2024-09-10');

-- 16. Association des nouvelles chansons aux répertoires
INSERT INTO repertoire_chanson (id_repertoire, id_chanson, ordre_chanson) VALUES
(11, 6, 1),
(11, 7, 2),
(12, 6, 1),
(12, 8, 2),
(13, 7, 1),
(13, 9, 2),
(14, 8, 1),
(14, 9, 2);

-- 17. Insertion de médias pour les nouvelles chansons
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, format_fichier, duree, description) VALUES
(6, 'audio', '/audios/miandry.mp3', 'mp3', '00:04:15', 'Version studio'),
(7, 'audio', '/audios/hoby.mp3', 'mp3', '00:03:55', 'Version live'),
(8, 'lyrics', '/lyrics/famindrana.txt', 'txt', NULL, 'Paroles complètes'),
(9, 'playback', '/playbacks/lalanao.mp3', 'mp3', '00:04:00', 'Playback instrumental');

-- Vérification finale
SELECT 'Toutes les insertions ont été effectuées avec succès !' AS status;
SELECT COUNT(*) AS total_chansons FROM chanson;
SELECT COUNT(*) AS total_sorties FROM sortie;
SELECT COUNT(*) AS total_reservations FROM reservation;


