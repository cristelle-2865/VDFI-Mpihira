-- =============================================
-- BASE DE DONNÉES : vdfi_mpihira
-- Convertie de MySQL vers PostgreSQL
-- =============================================

-- Créer et se connecter à la base (à exécuter en tant que superuser)
-- CREATE DATABASE vdfi_mpihira ENCODING 'UTF8';
-- \c vdfi_mpihira

-- =============================================
-- 1. TABLES DE RÉFÉRENCE
-- =============================================

-- Table statut
CREATE TABLE statut (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50)
);

INSERT INTO statut (id_statut, libelle) VALUES
(1, 'Créée'),
(2, 'Validée'),
(3, 'Annulée'),
(4, 'Refusée');
SELECT setval('statut_id_statut_seq', 4);

-- Table etat
CREATE TABLE etat (
    id_etat SERIAL PRIMARY KEY,
    nom_etat VARCHAR(50),
    description TEXT
);

INSERT INTO etat (id_etat, nom_etat, description) VALUES
(1, 'Planifiée', 'Sortie en cours de préparation'),
(2, 'Confirmée', 'Réservation validée et confirmée'),
(3, 'Annulée', 'Sortie annulée'),
(4, 'Terminée', 'Événement passé avec succès'),
(5, 'En cours', 'Événement en cours de déroulement');
SELECT setval('etat_id_etat_seq', 5);

-- Table statut_envoi
CREATE TABLE statut_envoi (
    id_statut_envoi SERIAL PRIMARY KEY,
    nom_statut VARCHAR(50),
    description TEXT
);

INSERT INTO statut_envoi (id_statut_envoi, nom_statut, description) VALUES
(1, 'En attente', 'En attente d''envoi'),
(2, 'Envoyé', 'Envoyé avec succès'),
(3, 'Échec', 'Échec d''envoi'),
(4, 'Lu', 'Ouvert par le destinataire');
SELECT setval('statut_envoi_id_statut_envoi_seq', 4);

-- Table lieu
CREATE TABLE lieu (
    id_lieu SERIAL PRIMARY KEY,
    nom_lieu VARCHAR(100),
    adresse TEXT
);
CREATE INDEX idx_lieu_nom ON lieu (nom_lieu);

INSERT INTO lieu (id_lieu, nom_lieu, adresse) VALUES
(1,  'METM Avaradoha',           'Avaradoha, Antananarivo'),
(2,  'FPVM Talatanivolonondry',  'Talatanivolonondry, Antananarivo'),
(3,  'FJKM Antanibe',            'Arivonimamo'),
(4,  'FJKM Ziona Vaovao',        'Anatanambao, Imerintsiatosika'),
(5,  'FJKM Ambavahadi Tokana',   'Itaosy, Antananarivo'),
(6,  'Salle Spectacle EXO',      'Antsahamanitra, Antananarivo'),
(7,  'FJKM Ikanja Fiderana',     'Antananarivo'),
(8,  'FJKM Tranovato',           'Isoamanangano, Antananarivo'),
(9,  'FPVM Ambohimahitsy',       'Ambohimahitsy, Antananarivo'),
(10, 'FLM Ambatonjara',          'Bypass, Antananarivo'),
(11, 'FJKM Ambatonakanga',       'Ambatonakanga, Antananarivo'),
(12, 'FPVM Alarobia',            'Ambatomanga, Madagascar'),
(13, 'METM Ambohidahy',          'Ankadidramamy, Antananarivo'),
(14, 'Astaruiat',                'Antanimena, Antananarivo'),
(15, 'FJKM Ziona Famonjena',     'Mamoladahy, Imerintsiatosika'),
(16, 'FJKM Lazaina',             'Lazaina, Madagascar'),
(17, 'Havoria',                  'Anosy, Antananarivo'),
(18, 'FPVM Soavimasoandro',      'Soavimasoandro, Madagascar'),
(19, 'FJKM Ambohimandroso',      'Ambohimandroso, Antananarivo'),
(20, 'FPVM Ambohimanarina',      'Ambohimanarina, Antananarivo');
SELECT setval('lieu_id_lieu_seq', 20);

-- =============================================
-- 2. ENTITÉS PRINCIPALES INDÉPENDANTES
-- =============================================

-- Table utilisateur
-- NOTE: ENUM MySQL → VARCHAR avec contrainte CHECK en PostgreSQL
CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    role VARCHAR(10) CHECK (role IN ('admin', 'membre')),
    telephone VARCHAR(20),
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_utilisateur_email ON utilisateur (email);

INSERT INTO utilisateur (id_utilisateur, nom, prenom, email, mot_de_passe, role, telephone, date_inscription) VALUES
(1, 'ADMIN',  'admin',  'admin@gmail.com',  'admin1',  'admin',  NULL, NULL),
(2, 'MEMBRE', 'membre', 'membre@gmail.com', 'membre1', 'membre', NULL, NULL);
SELECT setval('utilisateur_id_utilisateur_seq', 2);

-- Table membres
CREATE TABLE membres (
    id_membre SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    role VARCHAR(100),
    categorie VARCHAR(50) CHECK (categorie IN (
        'chef_de_choeur','responsable','auteur_compositeur',
        'chanteur','chanteuse','musicien','musicienne','technicienne'
    )),
    photo_path VARCHAR(255)
);
CREATE INDEX idx_membres_categorie ON membres (categorie);

INSERT INTO membres (id_membre, nom, prenom, role, categorie, photo_path) VALUES
(1,  'Zoky Vahatra',        NULL,                   '1er Responsable',                    'responsable',       '/photos/ZokyVahatra.jpg'),
(2,  'Zoky Holy',           NULL,                   '1ere Responsable',                   'responsable',       '/photos/ZokyHoly.jpg'),
(3,  'RASOAMANANA',         'Mbolatiana Toky',      'Auteur-Compositeur',                 'auteur_compositeur','/photos/Mbola.jpg'),
(4,  'ANDRIAMANJATO',       'Lahatriniavo Fandresena','Chef de Choeur',                   'chef_de_choeur',    '/photos/Fandresena.jpg'),
(5,  'ANDINIRINAMALALA',    'Anjara Tinatia',       'Responsable médias (photos, videos)','responsable',       '/photos/Tinatia.jpg'),
(6,  'RAFIRINGANIRINA',     'Lovatiana Zo',         '1ere voix',                          'chanteuse',         '/photos/Zo.jpg'),
(7,  'RAKOTOARISOA',        'Oniniaina',            '1ere voix',                          'chanteuse',         '/photos/Oniniaina.jpg'),
(8,  'RAKOTOMIHAJA',        'Tantanantsoa',         '1ere voix',                          'chanteuse',         '/photos/Tantanantsoa.jpg'),
(9,  'RAKOTONANAHARY',      'Tsirava Finiavana',    '1ere/2eme voix',                     'chanteuse',         '/photos/Tsirava.jpg'),
(10, 'RAHARINIRINA',        'Vonifanja Nathalie',   '2eme voix',                          'chanteuse',         '/photos/Nathalie.jpg'),
(12, 'ANDRIANTSIMANIRY',    'Iaritiana Famenontsoa','3eme voix',                          'chanteur',          '/photos/Famenontsoa.jpg'),
(13, 'RAKOTOMALALA',        'Fifaliana Mamilalaina','3eme voix',                          'chanteur',          '/photos/Fifaliana.jpg'),
(14, 'VAHATRINIAINA',       'Tiavo',                '3eme voix',                          'chanteur',          '/photos/Tiavo.jpg'),
(15, 'RALAIKOA',            'Falinirina Raphael Joseph','Claviériste',                    'musicien',          '/photos/Raphael.jpg'),
(16, 'NOMENJANAHARY',       'Sitrakiniaina Erick',  'Claviériste',                        'musicien',          '/photos/Erick.jpg'),
(17, 'RAZANADRAKOTO',       'Nirintsoa Heriniaina', 'Guitariste',                         'musicien',          '/photos/Aina.jpg'),
(18, 'LALAINAHARIJAONA',    'Anjara Toavina',       'Bassiste',                           'musicien',          '/photos/Toavina.jpg'),
(19, 'ANDRY NANTENAINA',    'Toky',                 'Batteur',                            'musicien',          '/photos/Toky.jpg'),
(20, 'RASOAMANANA',         'Mitia Talenta',        'Violiniste',                         'musicienne',        '/photos/Mitia.jpg');
SELECT setval('membres_id_membre_seq', 20);

-- Table chanson
-- NOTE: TIMESTAMP ... ON UPDATE → non supporté en PostgreSQL, géré par trigger si besoin
-- NOTE: NOW() est valide en PostgreSQL aussi
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
CREATE INDEX idx_chanson_titre        ON chanson (titre);
CREATE INDEX idx_chanson_genre        ON chanson (genre);
CREATE INDEX idx_chanson_auteur       ON chanson (auteur);
CREATE INDEX idx_chanson_date_creation ON chanson (date_creation);

INSERT INTO chanson (titre, paroles, auteur, genre, date_creation, partition_pdf) VALUES
('Ry Tompo tsara',
'Ry Tompo tsara o tsaroanay eto izao
Ny tananao mitantana anay
Ilay sandrinao mahery, no niahy sy nijery
ka tsy navelano izahay andeha irery ety
Ka rehefa injay ka tojon''ny fankampanahy
Dia niantsoantso anay izahay

Raha sendra tojo ny ady nampamohy fo
Sy mafy nampiondrika ny loha
Efa impiry moa izahay no efa trotraka
Solafaka eny fona eh ka mila ho potraka
Soa fa mbola tao Ianao Ry Jesoa Tompo mahery
Nintantana sy namapahery

Jesoa Malala oh indreto ny mpianatrao
Hanambara ny fitiavanao
Ka na dia eso sy latsa kapoka mety handratra
Hijiro izahay ho vavolombelonao
Nefa tsy ho vita na izany ratsy hombany
Ny herin''ny Fanahy Masinao

Ankehitriny izao no vetsoventsonay
Misaotra eh misaotra Anao izahay
Fa ny fahasoavanao no nahatoa izao anay
Ka raiso ry Jesosy oh izao vavaka izao
Izao fiarahantsika izao tsy ho foana tsy ho lao
Fa haharitra ho mandrakizay',
'Mbola Talenta', NULL, NULL, 'Ry_Tompo_Tsara.pdf'),

('Ingao',
'Ndeha hampiara peo hidera ilay Tsitoha
Fa mendrika azy ny voninahitra
Dia ilay tsy miova hatryny taloha anio ary ho mandrakizay
Iza no ahay hilaza ny hatsarany
Fatratra loatra ny fitiavany
Hihira ho Azy aho raha mbola velon''aina koa
Fa mahagaga loatra raha ny asany

Ingao ny feonao, hanandratra ny anarany
Ventsoy sy derao, Ilay Mpamonjy ahy sy ianao
Aza milofika intsony, jereo ilay ao ambony
Jesosy naharesy izao ontolo izao',
'YOON', NULL, NULL, 'Ingao.pdf'),

('Ndeha hiradia',
'Ndeha hampiara peo hidera ilay Tsitoha
Fa mendrika azy ny voninahitra
Dia ilay tsy miova hatryny taloha anio ary ho mandrakizay',
'YOON', NULL, NULL, 'Ndeha hiardia.pdf'),

('Hitako mamiratra',
'Hitako mamiratra ry jesoa ny ho aviko
Fa manana anao ehh
Ry tompo mpanjakako
Mitahy sy miaro mitondra ny lalako
Finoana tsy azo arina mandritra ny fiainako',
'Mbola Talenta', NULL, NULL, 'Hitako mamiratra.pdf'),

('Mibebaha',
'Fa ianao va izany tsimaintsy miaina amin''ny faharatsiana ?
F''efa hita f''ho loza sy ratsy dia mbola hiziriziriana
Tsy hamohy fa hifikitra foana amin''ny ota handatsaka andavaka',
'Fandresena', NULL, NULL, 'Mibebaha.pdf'),

('Henika sy Ampoka',
'Sambatra aho fa efa notiavinao
Lay nofidiko sy nifidy ahy
Enika sy ampokan''ny fanahy
Sambatra aho manana anao',
'Mbola Talenta', NULL, NULL, 'Henika sy Ampoka.pdf'),

('ILAY ORA TAO GETSEMANE',
'''Lay ora tao Getsemane no tsaroana eto indray
Mba tadidinao ve? tantaram-pamonjen''iray
Teo ''lay Tompo be fitia no naneho ny fitiavany',
'Mbola Talenta', NULL, NULL, 'Ilay ora tao Getsemane.pdf'),

('GETSEMANE',
'INDRO NY FITIAVAN-DEHIBE
NOMENAO HO AN''IZAO TONTOLO IZAO.
NASEHON''NY TOMPO TAO GETSEMANE
MBA HO AVOTRA, HO AHY SY IANAO',
'Mbola Talenta', NULL, NULL, 'GETSEMANE.pdf'),

('AMPOTOTRA',
'Fa eto ampototry ny hazo fijalianao
Tompo no anaterako ny otako
Fa tsy zakako, ka apetrako izao
Ekeo Tompo o ! ny fiverenako',
'Mbola Talenta', NULL, NULL, 'Ampototra.pdf'),

('MANDRAKIZAY NY FAMINDRAMPONY',
'Namako o, moa fantarao fa na izaho na ianao
Dia samy olona meloka avokoa
Mandrakizay ny famindrampony amiko aminao
Mandrakizay ny fitiavaNY antsika izao',
'Mbola Talenta', NULL, NULL, 'Mibebaha.pdf'),

('Ny Anaranao',
'TSY TAKATRY NY SAIKO
FA TIAKO SY LALAIKO
NY ANARANAO
RY TOMPONAY',
'Mbola Talenta', NULL, NULL, 'Ny_Anaranao.pdf'),

('Manana fanantenana',
'Na dia tsy mamotsina aza ny aviavy
Na dia tsy misy voany ny voaloboka
Manana finoana fa tsy maintsy ho avy
Ho tonga aminao ny valimbavaka',
'Mbola Talenta', NULL, NULL, 'Manana fanantenana.pdf'),

('Mba mahagaga loatra',
'Mba mahagaga loatra ny fitiavanao ry Tompo tia
Tena lehibe indrindra, ka tsy takatrin''ny sainay',
'Mbola Talenta', NULL, NULL, 'Mba mahagaga loatra.pdf'),

('Dia ho foana',
'Raha ny eto an-tany azo ambara tsotra ihany fanjakam-pahoriana sy tomany
Dia ho foana avokoa ny alahelo sy tomany ka ny ranomaso rehetra ho fafany',
'Mbola Talanta', NULL, NULL, 'Dia ho foana.pdf'),

('Mibebaha (Betesda)',
'Ry betesda
Nampifandray ny eto sy ny any
Reo anjely nidina no nahatonga izany',
'Zoky Vahatra', NULL, NULL, 'Bedesda.pdf'),

('Ho avy',
'Aza manamafy ny fonao intsony ianao
Fa raiso Jesosy Mpamonjy hanjaka amin''ny fiainanao e!
Ho avy Izy e! Ho avy am-boninahitra e!',
'Mbola Talenta', NULL, NULL, 'Ho avy.pdf'),

('Miantso anao',
'Moa fantatrao ry olona ô! izay manatrika eto anio
Ny zava-misy amin''izao fotoana izao
Koa miantso anao izao ny Tomponao',
'Mbola Talenta', NULL, NULL, 'Miansto anao.pdf'),

('Fa fitiavana',
'FA FITIAVANA FENO SY MARINA TOKOA
NO NATOLOTRAO AHY RE RY TOMPO
FA FITIAVANA SOA SAROBIDY',
'Mbola Talenta', NULL, NULL, 'Fa fitiavana.pdf'),

('Tsy hisy ahasaraka ahy',
'MANAIKY AHO IZAO ANIO IZAO
FA NANDREHA NY ANTSONAO
TS''ISY AHASARAKA AHY AMIN''NY FITIAVANAO',
'Mbola Talenta', NULL, NULL, 'Tsy hisy ahasaraka ahy.pdf'),

('Hitondra ambavaka',
'Topazo maso anie ny lasa
Ireo nodiavinao hatrizay
Hitondra ambavaka anao, n''inona n''inona atao',
'Fandresena', NULL, NULL, 'Hiutondra ambavaka.pdf');

SELECT setval('chanson_id_chanson_seq', 20);

-- Table photo
-- NOTE: les colonnes type_evenement et localisation étaient dans l'INSERT mais pas dans le CREATE TABLE original
-- Elles sont ajoutées ici pour cohérence avec les données
CREATE TABLE photo (
    id_photo SERIAL PRIMARY KEY,
    photo_path VARCHAR(255),
    legende TEXT,
    type_evenement VARCHAR(50),
    localisation VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO photo (id_photo, photo_path, legende, type_evenement, localisation, date_creation) VALUES
(1,  '/photos/metm_avaradoha.jpg',                              'METM Avaradoha',                        'sortie', 'Avaradoha',         '2024-10-27'),
(2,  '/photos/fpvm_talatanivolonondry.jpg',                     'FPVM Talatanivolonondry',               'sortie', 'Talatanivolonondry','2024-11-24'),
(3,  '/photos/fjkm_antanibe_fiainana_arivonimamo.jpg',          'FJKM Antanibe Fiainana Arivonimamo',    'sortie', 'Arivonimamo',       '2024-12-08'),
(4,  '/photos/fjkm_ziona_vaovao_tsarahonenana_imerintsiatosika.jpg','FJKM Ziona Vaovao Tsarahonenana','sortie', 'Imerintsiatosika',  '2025-04-06'),
(5,  '/photos/fjkm_ambavahadi_tokana_itaosy.jpg',               'FJKM Ambavahadi Tokana Itaosy',         'sortie', 'Itaosy',            '2025-04-27'),
(6,  '/photos/exo_antsahamanitra.jpg',                          'Spectacle EXO Antsahamanitra',          'sortie', 'Antsahamanitra',    '2025-05-03'),
(7,  '/photos/fjkm_ikanja_fiderana_arivonimamo.jpg',            'FJKM Ikanja Fiderana Arivonimamo',      'sortie', 'Arivonimamo',       '2025-05-04'),
(8,  '/photos/fjkm_tranovato_isoamanangano.jpg',                'FJKM Tranovato Isoamanangano',          'sortie', 'Isoamanangano',     '2025-05-11'),
(9,  '/photos/fjkm_antanibe_fiainana_arivonimamo.jpg',          'FJKM Antanibe Fiainana Arivonimamo',    'sortie', 'Arivonimamo',       '2025-05-18'),
(10, '/photos/fpvm_ambohimahitsy.jpg',                          'FPVM Ambohimahitsy',                    'sortie', 'Ambohimahitsy',     '2025-05-24'),
(11, '/photos/flm_ambatonjara_bypass.jpg',                      'FLM Ambatonjara Bypass',                'sortie', 'Ambatonjara',       '2025-06-22'),
(12, '/photos/fjkm_ambatonakanga.jpg',                          'FJKM Ambatonakanga',                    'sortie', 'Ambatonakanga',     '2025-07-06'),
(13, '/photos/fpvm_alarobia_ambatomanga.jpg',                   'FPVM Alarobia Ambatomanga',             'sortie', 'Ambatomanga',       '2025-07-12'),
(14, '/photos/metm_ambohidahy_ankadidramamy.jpg',               'METM Ambohidahy Ankadidramamy',         'sortie', 'Ankadidramamy',     '2025-07-20'),
(15, '/photos/astauriat_antanimena.jpg',                        'Astauriat Antanimena',                  'sortie', 'Antanimena',        '2025-07-27'),
(16, '/photos/fjkm_ziona_famonjena_imerintsiatosika.jpg',       'FJKM Ziona Famonjena Imerintsiatosika', 'sortie', 'Imerintsiatosika',  '2025-08-02'),
(17, '/photos/fjkm_lazaina.jpg',                                'FJKM Lazaina',                          'sortie', 'Lazaina',           '2025-08-03'),
(18, '/photos/havoria_anosy.jpg',                               'Havoria Anosy',                         'sortie', 'Anosy',             '2025-08-10'),
(19, '/photos/fpvm_soavimasoandro.jpg',                         'FPVM Soavimasoandro',                   'sortie', 'Soavimasoandro',    '2025-08-24'),
(20, '/photos/fjkm_ambohimandroso_ambatondrazaka.jpg',          'FJKM Ambohimandroso Ambatondrazaka',    'sortie', 'Ambatondrazaka',    '2025-08-31'),
(21, '/photos/fpvm_ambohimanarina.jpg',                         'FPVM Ambohimanarina',                   'sortie', 'Ambohimanarina',    '2025-09-14'),
(22, '/photos/fpvm_carion.jpg',                                 'FPVM Carion',                           'sortie', 'Carion',            '2025-10-26'),
(23, '/photos/fpvm_carion2.jpg',                                'FPVM Carion',                           'sortie', 'Carion',            '2025-11-09');
SELECT setval('photo_id_photo_seq', 23);

-- Table repertoire
CREATE TABLE repertoire (
    id_repertoire SERIAL PRIMARY KEY,
    date_preparation DATE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    titre VARCHAR(100)
);
CREATE INDEX idx_repertoire_date_preparation ON repertoire (date_preparation);
CREATE INDEX idx_repertoire_titre            ON repertoire (titre);

INSERT INTO repertoire (date_preparation, titre, description) VALUES
('2024-10-27', 'METM Avaradoha',                          'Préparation du répertoire pour METM Avaradoha.'),
('2024-11-24', 'FPVM Talatanivolonondry',                 'Préparation du répertoire pour FPVM Talatanivolonondry.'),
('2024-12-08', 'FJKM Antanibe Fiainana Arivonimamo',      'Préparation du répertoire pour FJKM Antanibe Fiainana Arivonimamo.'),
('2025-04-06', 'FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika','Préparation du répertoire pour FJKM Ziona Vaovao.'),
('2025-04-27', 'FJKM Ambavahadi Tokana Itaosy',           'Préparation du répertoire pour FJKM Ambavahadi Tokana Itaosy.'),
('2025-05-03', 'Spectacle EXO Antsahamanitra',            'Préparation du répertoire pour Spectacle EXO Antsahamanitra.'),
('2025-05-04', 'FJKM Ikanja Fiderana Arivonimamo',        'Préparation du répertoire pour FJKM Ikanja Fiderana Arivonimamo.'),
('2025-05-11', 'FJKM Tranovato Isoamanangano',            'Préparation du répertoire pour FJKM Tranovato Isoamanangano.'),
('2025-05-18', 'FJKM Antanibe Fiainana Arivonimamo',      'Préparation du répertoire pour FJKM Antanibe Fiainana Arivonimamo.'),
('2025-05-24', 'FPVM Ambohimahitsy',                      'Préparation du répertoire pour FPVM Ambohimahitsy.'),
('2025-06-22', 'FLM Ambatonjara Bypass',                  'Préparation du répertoire pour FLM Ambatonjara Bypass.'),
('2025-07-06', 'FJKM Ambatonakanga',                      'Préparation du répertoire pour FJKM Ambatonakanga.'),
('2025-07-12', 'FPVM Alarobia Ambatomanga',                'Préparation du répertoire pour FPVM Alarobia Ambatomanga.'),
('2025-07-20', 'METM Ambohidahy Ankadidramamy',            'Préparation du répertoire pour METM Ambohidahy Ankadidramamy.'),
('2025-07-27', 'Astauriat Antanimena',                    'Préparation du répertoire pour Astauriat Antanimena.'),
('2025-08-02', 'FJKM Ziona Famonjena Imerintsiatosika',   'Préparation du répertoire pour FJKM Ziona Famonjena Imerintsiatosika.'),
('2025-08-03', 'FJKM Lazaina',                            'Préparation du répertoire pour FJKM Lazaina.'),
('2025-08-10', 'Havoria Anosy',                           'Préparation du répertoire pour Havoria Anosy.'),
('2025-08-24', 'FPVM Soavimasoandro',                     'Préparation du répertoire pour FPVM Soavimasoandro.'),
('2025-08-31', 'FJKM Ambohimandroso Ambatondrazaka',      'Préparation du répertoire pour FJKM Ambohimandroso Ambatondrazaka.'),
('2025-09-14', 'FPVM Ambohimanarina',                     'Préparation du répertoire pour FPVM Ambohimanarina.'),
('2025-10-26', 'FPVM Carion',                             'Préparation du répertoire pour FPVM Carion.'),
('2025-11-09', 'FPVM Carion',                             'Préparation du répertoire pour FPVM Carion.');
SELECT setval('repertoire_id_repertoire_seq', 23);

-- =============================================
-- 3. TABLES DÉPENDANTES DU NIVEAU 1
-- =============================================

-- Table media_chanson
CREATE TABLE media_chanson (
    id_media_chanson SERIAL PRIMARY KEY,
    id_chanson INT,
    type_media VARCHAR(30) CHECK (type_media IN (
        'audio','video_clip','lyrics','playback','partition_pdf','parole_powerpoint'
    )),
    fichier_path VARCHAR(255),
    fichier_nom_original VARCHAR(255),
    taille_fichier INT,
    format_fichier VARCHAR(10),
    duree TIME,
    url_externe VARCHAR(500),
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_chanson) REFERENCES chanson(id_chanson) ON DELETE CASCADE
);
CREATE INDEX idx_media_chanson_type ON media_chanson (type_media);

-- AUDIO
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, duree, url_externe, description) VALUES
(1, 'audio', '/media/audio/ry_tompo_tsara.mp3',       'ry_tompo_tsara.mp3',       5000, 'mp3', '00:04:00', NULL, 'Audio officiel de Ry Tompo tsara'),
(2, 'audio', '/media/audio/ingao.mp3',                'ingao.mp3',                4800, 'mp3', '00:03:50', NULL, 'Audio officiel de Ingao'),
(8, 'audio', '/media/audio/hitako_mamiratra.mp3',     'hitako_mamiratra.mp3',     4900, 'mp3', '00:03:55', NULL, 'Audio officiel de Hitako mamiratra'),
(9, 'audio', '/media/audio/mibebaha.mp3',             'mibebaha.mp3',             4800, 'mp3', '00:03:50', NULL, 'Audio officiel de Mibebaha'),
(12,'audio', '/media/audio/ilay_ora_tao_getsemane.mp3','ilay_ora_tao_getsemane.mp3',4900,'mp3','00:03:55', NULL, 'Audio officiel de Ilay ora tao Getsemane'),
(13,'audio', '/media/audio/getsemane.mp3',            'getsemane.mp3',            4800, 'mp3', '00:03:40', NULL, 'Audio officiel de Getsemane'),
(14,'audio', '/media/audio/ampototra.mp3',            'ampototra.mp3',            4700, 'mp3', '00:03:35', NULL, 'Audio officiel de Ampototra'),
(15,'audio', '/media/audio/hitondra_ambavaka_anao.mp3','hitondra_ambavaka_anao.mp3',4900,'mp3','00:03:50',NULL, 'Audio officiel de Hitondra ambavaka anao');

-- VIDEO_CLIP
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, duree, url_externe, description) VALUES
(1,  'video_clip', '/media/video/ry_tompo_tsara.mp4',        'ry_tompo_tsara.mp4',        14800, 'mp4', '00:04:00', NULL, 'Clip vidéo de Ry Tompo tsara'),
(2,  'video_clip', '/media/video/ingao.mp4',                 'ingao.mp4',                 14000, 'mp4', '00:03:50', NULL, 'Clip vidéo de Ingao'),
(12, 'video_clip', '/media/video/ilay_ora_tao_getsemane.mp4','ilay_ora_tao_getsemane.mp4',14500, 'mp4', '00:03:55', NULL, 'Clip vidéo de Ilay ora tao Getsemane');

-- LYRICS
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, description) VALUES
(1,  'lyrics', '/media/lyrics/ry_tompo_tsara.txt',           'ry_tompo_tsara.txt',           10, 'txt', 'Paroles de Ry Tompo tsara'),
(2,  'lyrics', '/media/lyrics/ingao.txt',                    'ingao.txt',                     8, 'txt', 'Paroles de Ingao'),
(8,  'lyrics', '/media/lyrics/hitako_mamiratra.txt',         'hitako_mamiratra.txt',           9, 'txt', 'Paroles de Hitako mamiratra'),
(9,  'lyrics', '/media/lyrics/mibebaha.txt',                 'mibebaha.txt',                  8, 'txt', 'Paroles de Mibebaha'),
(12, 'lyrics', '/media/lyrics/ilay_ora_tao_getsemane.txt',  'ilay_ora_tao_getsemane.txt',     9, 'txt', 'Paroles de Ilay ora tao Getsemane'),
(13, 'lyrics', '/media/lyrics/getsemane.txt',               'getsemane.txt',                  8, 'txt', 'Paroles de Getsemane'),
(14, 'lyrics', '/media/lyrics/ampototra.txt',               'ampototra.txt',                  8, 'txt', 'Paroles de Ampototra'),
(15, 'lyrics', '/media/lyrics/hitondra_ambavaka_anao.txt',  'hitondra_ambavaka_anao.txt',      9, 'txt', 'Paroles de Hitondra ambavaka anao');

-- PLAYBACK
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, duree, description) VALUES
(1,  'playback', '/media/playback/ry_tompo_tsara.mp3',               'ry_tompo_tsara_playback.mp3',               4800, 'mp3', '00:04:00', 'Playback de Ry Tompo tsara'),
(2,  'playback', '/media/playback/ingao.mp3',                        'ingao_playback.mp3',                        4700, 'mp3', '00:03:50', 'Playback de Ingao'),
(3,  'playback', '/media/playback/ndeha_hiaradia.mp3',               'ndeha_hiaradia_playback.mp3',               4750, 'mp3', '00:03:55', 'Playback de Ndeha hiaradia'),
(4,  'playback', '/media/playback/manana_fanantenana.mp3',           'manana_fanantenana_playback.mp3',           4800, 'mp3', '00:04:00', 'Playback de Manana fanantenana'),
(5,  'playback', '/media/playback/henika_sy_ampoka.mp3',             'henika_sy_ampoka_playback.mp3',             4700, 'mp3', '00:03:45', 'Playback de Henika sy ampoka'),
(6,  'playback', '/media/playback/fa_fitiavana.mp3',                 'fa_fitiavana_playback.mp3',                 4650, 'mp3', '00:03:40', 'Playback de Fa fitiavana'),
(7,  'playback', '/media/playback/mahagaga_loatra.mp3',              'mahagaga_loatra_playback.mp3',              4800, 'mp3', '00:04:10', 'Playback de Mahagaga loatra'),
(8,  'playback', '/media/playback/hitako_mamiratra.mp3',             'hitako_mamiratra_playback.mp3',             4750, 'mp3', '00:03:55', 'Playback de Hitako mamiratra'),
(9,  'playback', '/media/playback/mibebaha.mp3',                     'mibebaha_playback.mp3',                     4700, 'mp3', '00:03:50', 'Playback de Mibebaha'),
(10, 'playback', '/media/playback/mandrakizay_ny_famindrampony.mp3', 'mandrakizay_ny_famindrampony_playback.mp3', 4800, 'mp3', '00:04:05', 'Playback de Mandrakizay ny famindrampony'),
(11, 'playback', '/media/playback/ny_anaranao.mp3',                  'ny_anaranao_playback.mp3',                  4650, 'mp3', '00:03:50', 'Playback de Ny Anaranao'),
(12, 'playback', '/media/playback/ilay_ora_tao_getsemane.mp3',       'ilay_ora_tao_getsemane_playback.mp3',       4750, 'mp3', '00:03:55', 'Playback de Ilay ora tao Getsemane'),
(13, 'playback', '/media/playback/getsemane.mp3',                    'getsemane_playback.mp3',                    4700, 'mp3', '00:03:40', 'Playback de Getsemane'),
(14, 'playback', '/media/playback/ampototra.mp3',                    'ampototra_playback.mp3',                    4650, 'mp3', '00:03:35', 'Playback de Ampototra'),
(15, 'playback', '/media/playback/hitondra_ambavaka_anao.mp3',       'hitondra_ambavaka_anao_playback.mp3',       4700, 'mp3', '00:03:50', 'Playback de Hitondra ambavaka anao'),
(16, 'playback', '/media/playback/ho_avy.mp3',                       'ho_avy_playback.mp3',                       4800, 'mp3', '00:04:00', 'Playback de Ho avy'),
(17, 'playback', '/media/playback/ry_betesda.mp3',                   'ry_betesda_playback.mp3',                   4700, 'mp3', '00:03:55', 'Playback de Ry Betesda'),
(18, 'playback', '/media/playback/miantso_anao.mp3',                 'miantso_anao_playback.mp3',                 4650, 'mp3', '00:03:50', 'Playback de Miantso anao'),
(19, 'playback', '/media/playback/dia_ho_foana.mp3',                 'dia_ho_foana_playback.mp3',                 4700, 'mp3', '00:03:55', 'Playback de Dia ho foana'),
(20, 'playback', '/media/playback/mpanjaka_ny_mpanjaka.mp3',         'mpanjaka_ny_mpanjaka_playback.mp3',         4800, 'mp3', '00:04:10', 'Playback de Mpanjaka ny Mpanjaka');

-- PARTITION PDF
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, description) VALUES
(1,  'partition_pdf', '/media/pdf/ry_tompo_tsara.pdf',               'ry_tompo_tsara.pdf',               500, 'pdf', 'Partition PDF de Ry Tompo tsara'),
(2,  'partition_pdf', '/media/pdf/ingao.pdf',                        'ingao.pdf',                        480, 'pdf', 'Partition PDF de Ingao'),
(3,  'partition_pdf', '/media/pdf/ndeha_hiaradia.pdf',               'ndeha_hiaradia.pdf',               490, 'pdf', 'Partition PDF de Ndeha hiaradia'),
(4,  'partition_pdf', '/media/pdf/manana_fanantenana.pdf',           'manana_fanantenana.pdf',           500, 'pdf', 'Partition PDF de Manana fanantenana'),
(5,  'partition_pdf', '/media/pdf/enika_sy_ampoka.pdf',              'enika_sy_ampoka.pdf',              480, 'pdf', 'Partition PDF de enika sy ampoka'),
(6,  'partition_pdf', '/media/pdf/fa_fitiavana.pdf',                 'fa_fitiavana.pdf',                 470, 'pdf', 'Partition PDF de Fa fitiavana'),
(7,  'partition_pdf', '/media/pdf/mahagaga_loatra.pdf',              'mahagaga_loatra.pdf',              500, 'pdf', 'Partition PDF de Mahagaga loatra'),
(8,  'partition_pdf', '/media/pdf/hitako_mamiratra.pdf',             'hitako_mamiratra.pdf',             490, 'pdf', 'Partition PDF de Hitako mamiratra'),
(9,  'partition_pdf', '/media/pdf/mibebaha.pdf',                     'mibebaha.pdf',                     480, 'pdf', 'Partition PDF de Mibebaha'),
(10, 'partition_pdf', '/media/pdf/mandrakizay_ny_famindrampony.pdf', 'mandrakizay_ny_famindrampony.pdf', 500, 'pdf', 'Partition PDF de Mandrakizay ny famindrampony'),
(11, 'partition_pdf', '/media/pdf/ny_anaranao.pdf',                  'ny_anaranao.pdf',                  470, 'pdf', 'Partition PDF de Ny Anaranao'),
(12, 'partition_pdf', '/media/pdf/ilay_ora_tao_getsemane.pdf',       'ilay_ora_tao_getsemane.pdf',       490, 'pdf', 'Partition PDF de Ilay ora tao Getsemane'),
(13, 'partition_pdf', '/media/pdf/getsemane.pdf',                    'getsemane.pdf',                    480, 'pdf', 'Partition PDF de Getsemane'),
(14, 'partition_pdf', '/media/pdf/ampototra.pdf',                    'ampototra.pdf',                    470, 'pdf', 'Partition PDF de Ampototra'),
(15, 'partition_pdf', '/media/pdf/hitondra_ambavaka_anao.pdf',       'hitondra_ambavaka_anao.pdf',       490, 'pdf', 'Partition PDF de Hitondra ambavaka anao'),
(16, 'partition_pdf', '/media/pdf/ho_avy.pdf',                       'ho_avy.pdf',                       500, 'pdf', 'Partition PDF de Ho avy'),
(17, 'partition_pdf', '/media/pdf/ry_betesda.pdf',                   'ry_betesda.pdf',                   470, 'pdf', 'Partition PDF de Ry Betesda'),
(18, 'partition_pdf', '/media/pdf/miantso_anao.pdf',                 'miantso_anao.pdf',                 470, 'pdf', 'Partition PDF de Miantso anao'),
(19, 'partition_pdf', '/media/pdf/dia_ho_foana.pdf',                 'dia_ho_foana.pdf',                 490, 'pdf', 'Partition PDF de Dia ho foana'),
(20, 'partition_pdf', '/media/pdf/mpanjaka_ny_mpanjaka.pdf',         'mpanjaka_ny_mpanjaka.pdf',         500, 'pdf', 'Partition PDF de Mpanjaka ny Mpanjaka');

-- PAROLE POWERPOINT
INSERT INTO media_chanson (id_chanson, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, description) VALUES
(1,  'parole_powerpoint', '/media/ppt/ry_tompo_tsara.pptx',               'ry_tompo_tsara.pptx',               600, 'pptx', 'Parole PowerPoint de Ry Tompo tsara'),
(2,  'parole_powerpoint', '/media/ppt/ingao.pptx',                        'ingao.pptx',                        580, 'pptx', 'Parole PowerPoint de Ingao'),
(3,  'parole_powerpoint', '/media/ppt/ndeha_hiaradia.pptx',               'ndeha_hiaradia.pptx',               590, 'pptx', 'Parole PowerPoint de Ndeha hiaradia'),
(4,  'parole_powerpoint', '/media/ppt/manana_fanantenana.pptx',           'manana_fanantenana.pptx',           600, 'pptx', 'Parole PowerPoint de Manana fanantenana'),
(5,  'parole_powerpoint', '/media/ppt/enika_sy_ampoka.pptx',              'enika_sy_ampoka.pptx',              580, 'pptx', 'Parole PowerPoint de enika sy ampoka'),
(6,  'parole_powerpoint', '/media/ppt/fa_fitiavana.pptx',                 'fa_fitiavana.pptx',                 570, 'pptx', 'Parole PowerPoint de Fa fitiavana'),
(7,  'parole_powerpoint', '/media/ppt/mahagaga_loatra.pptx',              'mahagaga_loatra.pptx',              600, 'pptx', 'Parole PowerPoint de Mahagaga loatra'),
(8,  'parole_powerpoint', '/media/ppt/hitako_mamiratra.pptx',             'hitako_mamiratra.pptx',             590, 'pptx', 'Parole PowerPoint de Hitako mamiratra'),
(9,  'parole_powerpoint', '/media/ppt/mibebaha.pptx',                     'mibebaha.pptx',                     580, 'pptx', 'Parole PowerPoint de Mibebaha'),
(10, 'parole_powerpoint', '/media/ppt/mandrakizay_ny_famindrampony.pptx', 'mandrakizay_ny_famindrampony.pptx', 600, 'pptx', 'Parole PowerPoint de Mandrakizay ny famindrampony'),
(11, 'parole_powerpoint', '/media/ppt/ny_anaranao.pptx',                  'ny_anaranao.pptx',                  570, 'pptx', 'Parole PowerPoint de Ny Anaranao'),
(12, 'parole_powerpoint', '/media/ppt/ilay_ora_tao_getsemane.pptx',       'ilay_ora_tao_getsemane.pptx',       590, 'pptx', 'Parole PowerPoint de Ilay ora tao Getsemane'),
(13, 'parole_powerpoint', '/media/ppt/getsemane.pptx',                    'getsemane.pptx',                    580, 'pptx', 'Parole PowerPoint de Getsemane'),
(14, 'parole_powerpoint', '/media/ppt/ampototra.pptx',                    'ampototra.pptx',                    570, 'pptx', 'Parole PowerPoint de Ampototra'),
(15, 'parole_powerpoint', '/media/ppt/hitondra_ambavaka_anao.pptx',       'hitondra_ambavaka_anao.pptx',       590, 'pptx', 'Parole PowerPoint de Hitondra ambavaka anao'),
(16, 'parole_powerpoint', '/media/ppt/ho_avy.pptx',                       'ho_avy.pptx',                       600, 'pptx', 'Parole PowerPoint de Ho avy'),
(17, 'parole_powerpoint', '/media/ppt/ry_betesda.pptx',                   'ry_betesda.pptx',                   580, 'pptx', 'Parole PowerPoint de Ry Betesda'),
(18, 'parole_powerpoint', '/media/ppt/miantso_anao.pptx',                 'miantso_anao.pptx',                 570, 'pptx', 'Parole PowerPoint de Miantso anao'),
(19, 'parole_powerpoint', '/media/ppt/dia_ho_foana.pptx',                 'dia_ho_foana.pptx',                 590, 'pptx', 'Parole PowerPoint de Dia ho foana'),
(20, 'parole_powerpoint', '/media/ppt/mpanjaka_ny_mpanjaka.pptx',         'mpanjaka_ny_mpanjaka.pptx',         600, 'pptx', 'Parole PowerPoint de Mpanjaka ny Mpanjaka');

-- Table repertoire_chanson
CREATE TABLE repertoire_chanson (
    id_repertoire_chanson SERIAL PRIMARY KEY,
    id_repertoire INT,
    id_chanson INT,
    ordre_chanson INT DEFAULT 0,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_repertoire) REFERENCES repertoire(id_repertoire) ON DELETE CASCADE,
    FOREIGN KEY (id_chanson)    REFERENCES chanson(id_chanson)    ON DELETE CASCADE,
    UNIQUE (id_repertoire, id_chanson)
);
CREATE INDEX idx_repertoire_chanson_ordre ON repertoire_chanson (ordre_chanson);

INSERT INTO repertoire_chanson (id_repertoire, id_chanson, ordre_chanson) VALUES
(1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,5,5),(1,6,6),(1,7,7),(1,8,8),(1,9,9),(1,10,10),(1,11,11),(1,12,12),(1,13,13),(1,14,14),(1,15,15),(1,16,16),(1,17,17),(1,18,18),(1,19,19),(1,20,20),
(2,1,1),(2,2,2),(2,3,3),(2,4,4),(2,5,5),(2,6,6),(2,7,7),(2,8,8),(2,9,9),(2,10,10),(2,11,11),(2,12,12),(2,13,13),(2,14,14),(2,15,15),(2,16,16),(2,17,17),(2,18,18),(2,19,19),(2,20,20),
(3,1,1),(3,2,2),(3,3,3),(3,4,4),(3,5,5),(3,6,6),(3,7,7),(3,8,8),(3,9,9),(3,10,10),(3,11,11),(3,12,12),(3,13,13),(3,14,14),(3,15,15),(3,16,16),(3,17,17),(3,18,18),(3,19,19),(3,20,20),
(4,1,1),(4,2,2),(4,3,3),(4,4,4),(4,5,5),(4,6,6),(4,7,7),(4,8,8),(4,9,9),(4,10,10),(4,11,11),(4,12,12),(4,13,13),(4,14,14),(4,15,15),(4,16,16),(4,17,17),(4,18,18),(4,19,19),(4,20,20),
(5,1,1),(5,2,2),(5,3,3),(5,4,4),(5,5,5),(5,6,6),(5,7,7),(5,8,8),(5,9,9),(5,10,10),(5,11,11),(5,12,12),(5,13,13),(5,14,14),(5,15,15),(5,16,16),(5,17,17),(5,18,18),(5,19,19),(5,20,20),
(6,1,1),(6,2,2),(6,3,3),(6,4,4),(6,5,5),(6,6,6),(6,7,7),(6,8,8),(6,9,9),(6,10,10),(6,11,11),(6,12,12),(6,13,13),(6,14,14),(6,15,15),(6,16,16),(6,17,17),(6,18,18),(6,19,19),(6,20,20),
(7,1,1),(7,2,2),(7,3,3),(7,4,4),(7,5,5),(7,6,6),(7,7,7),(7,8,8),(7,9,9),(7,10,10),(7,11,11),(7,12,12),(7,13,13),(7,14,14),(7,15,15),(7,16,16),(7,17,17),(7,18,18),(7,19,19),(7,20,20),
(8,1,1),(8,2,2),(8,3,3),(8,4,4),(8,5,5),(8,6,6),(8,7,7),(8,8,8),(8,9,9),(8,10,10),(8,11,11),(8,12,12),(8,13,13),(8,14,14),(8,15,15),(8,16,16),(8,17,17),(8,18,18),(8,19,19),(8,20,20),
(9,1,1),(9,2,2),(9,3,3),(9,4,4),(9,5,5),(9,6,6),(9,7,7),(9,8,8),(9,9,9),(9,10,10),(9,11,11),(9,12,12),(9,13,13),(9,14,14),(9,15,15),(9,16,16),(9,17,17),(9,18,18),(9,19,19),(9,20,20),
(10,1,1),(10,2,2),(10,3,3),(10,4,4),(10,5,5),(10,6,6),(10,7,7),(10,8,8),(10,9,9),(10,10,10),(10,11,11),(10,12,12),(10,13,13),(10,14,14),(10,15,15),(10,16,16),(10,17,17),(10,18,18),(10,19,19),(10,20,20),
(11,1,1),(11,2,2),(11,3,3),(11,4,4),(11,5,5),(11,6,6),(11,7,7),(11,8,8),(11,9,9),(11,10,10),(11,11,11),(11,12,12),(11,13,13),(11,14,14),(11,15,15),(11,16,16),(11,17,17),(11,18,18),(11,19,19),(11,20,20),
(12,1,1),(12,2,2),(12,3,3),(12,4,4),(12,5,5),(12,6,6),(12,7,7),(12,8,8),(12,9,9),(12,10,10),(12,11,11),(12,12,12),(12,13,13),(12,14,14),(12,15,15),(12,16,16),(12,17,17),(12,18,18),(12,19,19),(12,20,20),
(13,1,1),(13,2,2),(13,3,3),(13,4,4),(13,5,5),(13,6,6),(13,7,7),(13,8,8),(13,9,9),(13,10,10),(13,11,11),(13,12,12),(13,13,13),(13,14,14),(13,15,15),(13,16,16),(13,17,17),(13,18,18),(13,19,19),(13,20,20),
(14,1,1),(14,2,2),(14,3,3),(14,4,4),(14,5,5),(14,6,6),(14,7,7),(14,8,8),(14,9,9),(14,10,10),(14,11,11),(14,12,12),(14,13,13),(14,14,14),(14,15,15),(14,16,16),(14,17,17),(14,18,18),(14,19,19),(14,20,20),
(15,1,1),(15,2,2),(15,3,3),(15,4,4),(15,5,5),(15,6,6),(15,7,7),(15,8,8),(15,9,9),(15,10,10),(15,11,11),(15,12,12),(15,13,13),(15,14,14),(15,15,15),(15,16,16),(15,17,17),(15,18,18),(15,19,19),(15,20,20),
(16,1,1),(16,2,2),(16,3,3),(16,4,4),(16,5,5),(16,6,6),(16,7,7),(16,8,8),(16,9,9),(16,10,10),(16,11,11),(16,12,12),(16,13,13),(16,14,14),(16,15,15),(16,16,16),(16,17,17),(16,18,18),(16,19,19),(16,20,20),
(17,1,1),(17,2,2),(17,3,3),(17,4,4),(17,5,5),(17,6,6),(17,7,7),(17,8,8),(17,9,9),(17,10,10),(17,11,11),(17,12,12),(17,13,13),(17,14,14),(17,15,15),(17,16,16),(17,17,17),(17,18,18),(17,19,19),(17,20,20),
(18,1,1),(18,2,2),(18,3,3),(18,4,4),(18,5,5),(18,6,6),(18,7,7),(18,8,8),(18,9,9),(18,10,10),(18,11,11),(18,12,12),(18,13,13),(18,14,14),(18,15,15),(18,16,16),(18,17,17),(18,18,18),(18,19,19),(18,20,20),
(19,1,1),(19,2,2),(19,3,3),(19,4,4),(19,5,5),(19,6,6),(19,7,7),(19,8,8),(19,9,9),(19,10,10),(19,11,11),(19,12,12),(19,13,13),(19,14,14),(19,15,15),(19,16,16),(19,17,17),(19,18,18),(19,19,19),(19,20,20),
(20,1,1),(20,2,2),(20,3,3),(20,4,4),(20,5,5),(20,6,6),(20,7,7),(20,8,8),(20,9,9),(20,10,10),(20,11,11),(20,12,12),(20,13,13),(20,14,14),(20,15,15),(20,16,16),(20,17,17),(20,18,18),(20,19,19),(20,20,20),
(21,1,1),(21,2,2),(21,3,3),(21,4,4),(21,5,5),(21,6,6),(21,7,7),(21,8,8),(21,9,9),(21,10,10),(21,11,11),(21,12,12),(21,13,13),(21,14,14),(21,15,15),(21,16,16),(21,17,17),(21,18,18),(21,19,19),(21,20,20),
(22,1,1),(22,2,2),(22,3,3),(22,4,4),(22,5,5),(22,6,6),(22,7,7),(22,8,8),(22,9,9),(22,10,10),(22,11,11),(22,12,12),(22,13,13),(22,14,14),(22,15,15),(22,16,16),(22,17,17),(22,18,18),(22,19,19),(22,20,20),
(23,1,1),(23,2,2),(23,3,3),(23,4,4),(23,5,5),(23,6,6),(23,7,7),(23,8,8),(23,9,9),(23,10,10),(23,11,11),(23,12,12),(23,13,13),(23,14,14),(23,15,15),(23,16,16),(23,17,17),(23,18,18),(23,19,19),(23,20,20);

-- =============================================
-- 3 (suite). TABLE RESERVATION
-- =============================================

CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,
    id_utilisateur INT,
    nom_eglise VARCHAR(100),
    adresse_eglise TEXT,
    contact VARCHAR(100),
    email_contact VARCHAR(100),
    date_evenement DATE,
    periode_journee VARCHAR(20) CHECK (periode_journee IN ('matin','après-midi','toute-la-journee')),
    description_reservation TEXT,
    sono_complet BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_statut INT,
    id_lieu INT,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (id_statut)      REFERENCES statut(id_statut),
    FOREIGN KEY (id_lieu)        REFERENCES lieu(id_lieu)
);
CREATE INDEX idx_reservation_date ON reservation (date_evenement);

INSERT INTO reservation (id_utilisateur, nom_eglise, adresse_eglise, contact, email_contact, date_evenement, periode_journee, description_reservation, sono_complet, id_statut, id_lieu) VALUES
(1, 'METM Avaradoha',                               'Avaradoha, Antananarivo',    NULL,          'contact@metmavaradoha.mg',           '2024-10-27', 'matin',          'Culte de dimanche matin',    TRUE,  1, 1),
(2, 'FPVM Talatanivolonondry',                       'Talatanivolonondry, Antananarivo', NULL,    'contact@fpvmtalatanivolonondry.mg',  '2024-11-24', 'après-midi',     'Répétition de louange',      FALSE, 2, 2),
(3, 'FJKM Antanibe Fiainana Arivonimamo',            'Arivonimamo',               '0343456789',  'contact@fjkmantanibe.mg',            '2024-12-08', 'toute-la-journee','Événement communautaire',   TRUE,  1, 3),
(1, 'FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika','Imerintsiatosika',        '0344567890',  'contact@fjkmziona.mg',               '2025-04-06', 'matin',          'Culte de dimanche',          FALSE, 1, 4),
(2, 'FJKM Ambavahadi Tokana Itaosy',                'Itaosy, Antananarivo',       '0345678901',  'contact@fjkmambavahadi.mg',          '2025-04-27', 'après-midi',     'Concert de louange',         TRUE,  2, 5),
(3, 'Spectacle EXO Antsahamanitra',                 'Antsahamanitra, Antananarivo','0346789012', 'contact@exoantsahamanitra.mg',       '2025-05-03', 'toute-la-journee','Spectacle musical',          TRUE,  1, 6),
(1, 'FJKM Ikanja Fiderana Arivonimamo',             'Arivonimamo',               '0347890123',  'contact@fjkmikanja.mg',              '2025-05-04', 'matin',          'Répétition générale',        FALSE, 2, 7),
(2, 'FJKM Tranovato Isoamanangano',                 'Tranovato',                 '0348901234',  'contact@fjkmtranovato.mg',           '2025-05-11', 'après-midi',     'Culte spécial',              TRUE,  1, 8),
(3, 'FJKM Antanibe Fiainana Arivonimamo',           'Arivonimamo',               '0349012345',  'contact@fjkmantanibe2.mg',           '2025-05-18', 'toute-la-journee','Culte de louange',           FALSE, 1, 3),
(1, 'FPVM Ambohimahitsy',                           'Ambohimahitsy, Antananarivo','0341123456', 'contact@fpvmambohimahitsy.mg',       '2025-05-24', 'matin',          'Répétition chorale',         TRUE,  2, 2),
(2, 'FLM Ambatonjara Bypass',                       'Ambatonjara',               '0342234567',  'contact@flmambatonjara.mg',          '2025-06-22', 'après-midi',     'Culte de semaine',           FALSE, 1, 9),
(3, 'FJKM Ambatonakanga',                           'Ambatonakanga',             '0343345678',  'contact@fjkmambatonakanga.mg',       '2025-07-06', 'toute-la-journee','Événement communautaire',   TRUE,  1, 10),
(1, 'FPVM Alarobia Ambatomanga',                    'Ambatomanga',               '0344456789',  'contact@fpvmalarobia.mg',            '2025-07-12', 'matin',          'Répétition de musique',      FALSE, 2, 11),
(2, 'METM Ambohidahy Ankadidramamy',                'Ambohidahy',                '0345567890',  'contact@metmankadidramamy.mg',       '2025-07-20', 'après-midi',     'Culte de louange',           TRUE,  1, 1),
(3, 'Astauriat Antanimena',                         'Antanimena, Antananarivo',  '0346678901',  'contact@astauriat.mg',               '2025-07-27', 'toute-la-journee','Événement musical',          TRUE,  2, 12),
(1, 'FJKM Ziona Famonjena Imerintsiatosika',        'Imerintsiatosika',          '0347789012',  'contact@fjkmziona2.mg',              '2025-08-02', 'matin',          'Répétition générale',        FALSE, 1, 4),
(2, 'FJKM Lazaina',                                 'Lazaina',                   '0348890123',  'contact@fjkmlazaina.mg',             '2025-08-03', 'après-midi',     'Culte spécial',              TRUE,  1, 13),
(3, 'Havoria Anosy',                                'Anosy, Antananarivo',       '0349901234',  'contact@havoria.mg',                 '2025-08-10', 'toute-la-journee','Concert musical',            TRUE,  2, 14),
(1, 'FPVM Soavimasoandro',                          'Soavimasoandro',            '0341012345',  'contact@fpvmsoavimasoandro.mg',      '2025-08-24', 'matin',          'Répétition de louange',      FALSE, 1, 15),
(2, 'FJKM Ambohimandroso Ambatondrazaka',           'Ambatondrazaka',            '0342123456',  'contact@fjkmambohimandroso.mg',      '2025-08-31', 'après-midi',     'Culte de dimanche',          TRUE,  1, 16),
(3, 'FPVM Ambohimanarina',                          'Ambohimanarina',            '0343234567',  'contact@fpvmambohimanarina.mg',      '2025-09-14', 'toute-la-journee','Événement communautaire',   FALSE, 2, 17),
(1, 'FPVM Carion',                                  'Carion, Antananarivo',      '0344345678',  'contact@fpvmcarion.mg',              '2025-10-26', 'matin',          'Culte spécial',              TRUE,  1, 18);
SELECT setval('reservation_id_reservation_seq', 22);

-- =============================================
-- 4. TABLES DÉPENDANTES DU NIVEAU 2
-- =============================================

-- Table reservation_statut
CREATE TABLE reservation_statut (
    id_res_statut SERIAL PRIMARY KEY,
    id_reservation INT,
    id_statut INT,
    date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation) ON DELETE CASCADE,
    FOREIGN KEY (id_statut)      REFERENCES statut(id_statut)
);

INSERT INTO reservation_statut (id_reservation, id_statut, date_changement) VALUES
(1,1,'2024-10-27 08:00:00'),(2,1,'2024-11-24 08:00:00'),(3,1,'2024-12-08 08:00:00'),
(4,1,'2025-04-06 08:00:00'),(5,1,'2025-04-27 08:00:00'),(6,1,'2025-05-03 08:00:00'),
(7,1,'2025-05-04 08:00:00'),(8,1,'2025-05-11 08:00:00'),(9,1,'2025-05-18 08:00:00'),
(10,1,'2025-05-24 08:00:00'),(11,1,'2025-06-22 08:00:00'),(12,1,'2025-07-06 08:00:00'),
(13,1,'2025-07-12 08:00:00'),(14,1,'2025-07-20 08:00:00'),(15,1,'2025-07-27 08:00:00'),
(16,1,'2025-08-02 08:00:00'),(17,1,'2025-08-03 08:00:00'),(18,1,'2025-08-10 08:00:00'),
(19,1,'2025-08-24 08:00:00'),(20,1,'2025-08-31 08:00:00'),(21,1,'2025-09-14 08:00:00'),
(22,1,'2025-10-26 08:00:00'),(23,1,'2025-11-09 08:00:00');

-- Table sortie
CREATE TABLE sortie (
    id_sortie SERIAL PRIMARY KEY,
    id_reservation INT NOT NULL,
    id_lieu INT NOT NULL,
    id_etat INT NOT NULL,
    id_photo INT,
    date_sortie TIMESTAMP NOT NULL,
    description TEXT,
    FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation) ON DELETE CASCADE,
    FOREIGN KEY (id_lieu)        REFERENCES lieu(id_lieu),
    FOREIGN KEY (id_etat)        REFERENCES etat(id_etat),
    FOREIGN KEY (id_photo)       REFERENCES photo(id_photo)
);
CREATE INDEX idx_sortie_date ON sortie (date_sortie);

INSERT INTO sortie (id_reservation, id_lieu, id_etat, id_photo, date_sortie, description) VALUES
(1,  1,  1, 1,  '2024-10-27', 'METM Avaradoha'),
(2,  2,  1, 2,  '2024-11-24', 'FPVM Talatanivolonondry'),
(3,  3,  1, 3,  '2024-12-08', 'FJKM Antanibe Fiainana Arivonimamo'),
(4,  4,  1, 4,  '2025-04-06', 'FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika'),
(5,  5,  1, 5,  '2025-04-27', 'FJKM Ambavahadi Tokana Itaosy'),
(6,  6,  1, 6,  '2025-05-03', 'Spectacle EXO Antsahamanitra'),
(7,  7,  1, 7,  '2025-05-04', 'FJKM Ikanja Fiderana Arivonimamo'),
(8,  8,  1, 8,  '2025-05-11', 'FJKM Tranovato Isoamanangano'),
(9,  3,  1, 9,  '2025-05-18', 'FJKM Antanibe Fiainana Arivonimamo'),
(10, 2,  1, 10, '2025-05-24', 'FPVM Ambohimahitsy'),
(11, 9,  1, 11, '2025-06-22', 'FLM Ambatonjara Bypass'),
(12, 10, 1, 12, '2025-07-06', 'FJKM Ambatonakanga'),
(13, 11, 1, 13, '2025-07-12', 'FPVM Alarobia Ambatomanga'),
(14, 1,  1, 14, '2025-07-20', 'METM Ambohidahy Ankadidramamy'),
(15, 12, 1, 15, '2025-07-27', 'Astauriat Antanimena'),
(16, 4,  1, 16, '2025-08-02', 'FJKM Ziona Famonjena Imerintsiatosika'),
(17, 13, 1, 17, '2025-08-03', 'FJKM Lazaina'),
(18, 14, 1, 18, '2025-08-10', 'Havoria Anosy'),
(19, 15, 1, 19, '2025-08-24', 'FPVM Soavimasoandro'),
(20, 16, 1, 20, '2025-08-31', 'FJKM Ambohimandroso Ambatondrazaka'),
(21, 17, 1, 21, '2025-09-14', 'FPVM Ambohimanarina'),
(22, 18, 1, 22, '2025-10-26', 'FPVM Carion'),
(23, 5,  1, 23, '2025-11-09', 'FJKM Ambavahadi Tokana Itaosy');
SELECT setval('sortie_id_sortie_seq', 23);

-- =============================================
-- 5. TABLES DÉPENDANTES DU NIVEAU 3
-- =============================================

-- Table sortie_repertoire
CREATE TABLE sortie_repertoire (
    id_sortie_repertoire SERIAL PRIMARY KEY,
    id_sortie INT,
    id_repertoire INT,
    date_utilisation DATE,
    FOREIGN KEY (id_sortie)     REFERENCES sortie(id_sortie)     ON DELETE CASCADE,
    FOREIGN KEY (id_repertoire) REFERENCES repertoire(id_repertoire) ON DELETE CASCADE,
    UNIQUE (id_sortie, id_repertoire)
);

INSERT INTO sortie_repertoire (id_sortie, id_repertoire, date_utilisation) VALUES
(1,1,'2024-10-27'),(2,2,'2024-11-24'),(3,3,'2024-12-08'),(4,4,'2025-04-06'),(5,5,'2025-04-27'),
(6,6,'2025-05-03'),(7,7,'2025-05-04'),(8,8,'2025-05-11'),(9,9,'2025-05-18'),(10,10,'2025-05-24'),
(11,11,'2025-06-22'),(12,12,'2025-07-06'),(13,13,'2025-07-12'),(14,14,'2025-07-20'),(15,15,'2025-07-27'),
(16,16,'2025-08-02'),(17,17,'2025-08-03'),(18,18,'2025-08-10'),(19,19,'2025-08-24'),(20,20,'2025-08-31'),
(21,21,'2025-09-14'),(22,22,'2025-10-26'),(23,23,'2025-11-09');

-- Table sortie_membres
CREATE TABLE sortie_membres (
    id_sortie_membre SERIAL PRIMARY KEY,
    id_sortie INT NOT NULL,
    id_membre INT NOT NULL,
    role_dans_sortie VARCHAR(100),
    FOREIGN KEY (id_sortie) REFERENCES sortie(id_sortie)  ON DELETE CASCADE,
    FOREIGN KEY (id_membre) REFERENCES membres(id_membre) ON DELETE CASCADE,
    UNIQUE (id_sortie, id_membre)
);

INSERT INTO sortie_membres (id_sortie, id_membre, role_dans_sortie) VALUES
(1,1,'Chanteur'),(1,2,'Chanteuse'),(1,3,'Musicien'),(1,4,'Musicienne'),(1,5,'Responsable'),(1,6,'Technicienne'),
(2,1,'Chanteur'),(2,2,'Chanteuse'),(2,3,'Musicien'),(2,4,'Musicienne'),(2,5,'Responsable'),(2,6,'Technicienne'),
(3,1,'Chanteur'),(3,2,'Chanteuse'),(3,3,'Musicien'),(3,4,'Musicienne'),(3,5,'Responsable'),(3,6,'Technicienne'),
(4,1,'Chanteur'),(4,2,'Chanteuse'),(4,3,'Musicien'),(4,4,'Musicienne'),(4,5,'Responsable'),(4,6,'Technicienne'),
(5,1,'Chanteur'),(5,2,'Chanteuse'),(5,3,'Musicien'),(5,4,'Musicienne'),(5,5,'Responsable'),(5,6,'Technicienne'),
(6,1,'Chanteur'),(6,2,'Chanteuse'),(6,3,'Musicien'),(6,4,'Musicienne'),(6,5,'Responsable'),(6,6,'Technicienne'),
(7,1,'Chanteur'),(7,2,'Chanteuse'),(7,3,'Musicien'),(7,4,'Musicienne'),(7,5,'Responsable'),(7,6,'Technicienne'),
(8,1,'Chanteur'),(8,2,'Chanteuse'),(8,3,'Musicien'),(8,4,'Musicienne'),(8,5,'Responsable'),(8,6,'Technicienne'),
(9,1,'Chanteur'),(9,2,'Chanteuse'),(9,3,'Musicien'),(9,4,'Musicienne'),(9,5,'Responsable'),(9,6,'Technicienne'),
(10,1,'Chanteur'),(10,2,'Chanteuse'),(10,3,'Musicien'),(10,4,'Musicienne'),(10,5,'Responsable'),(10,6,'Technicienne'),
(11,1,'Chanteur'),(11,2,'Chanteuse'),(11,3,'Musicien'),(11,4,'Musicienne'),(11,5,'Responsable'),(11,6,'Technicienne'),
(12,1,'Chanteur'),(12,2,'Chanteuse'),(12,3,'Musicien'),(12,4,'Musicienne'),(12,5,'Responsable'),(12,6,'Technicienne'),
(13,1,'Chanteur'),(13,2,'Chanteuse'),(13,3,'Musicien'),(13,4,'Musicienne'),(13,5,'Responsable'),(13,6,'Technicienne'),
(14,1,'Chanteur'),(14,2,'Chanteuse'),(14,3,'Musicien'),(14,4,'Musicienne'),(14,5,'Responsable'),(14,6,'Technicienne'),
(15,1,'Chanteur'),(15,2,'Chanteuse'),(15,3,'Musicien'),(15,4,'Musicienne'),(15,5,'Responsable'),(15,6,'Technicienne'),
(16,1,'Chanteur'),(16,2,'Chanteuse'),(16,3,'Musicien'),(16,4,'Musicienne'),(16,5,'Responsable'),(16,6,'Technicienne'),
(17,1,'Chanteur'),(17,2,'Chanteuse'),(17,3,'Musicien'),(17,4,'Musicienne'),(17,5,'Responsable'),(17,6,'Technicienne'),
(18,1,'Chanteur'),(18,2,'Chanteuse'),(18,3,'Musicien'),(18,4,'Musicienne'),(18,5,'Responsable'),(18,6,'Technicienne'),
(19,1,'Chanteur'),(19,2,'Chanteuse'),(19,3,'Musicien'),(19,4,'Musicienne'),(19,5,'Responsable'),(19,6,'Technicienne'),
(20,1,'Chanteur'),(20,2,'Chanteuse'),(20,3,'Musicien'),(20,4,'Musicienne'),(20,5,'Responsable'),(20,6,'Technicienne'),
(21,1,'Chanteur'),(21,2,'Chanteuse'),(21,3,'Musicien'),(21,4,'Musicienne'),(21,5,'Responsable'),(21,6,'Technicienne'),
(22,1,'Chanteur'),(22,2,'Chanteuse'),(22,3,'Musicien'),(22,4,'Musicienne'),(22,5,'Responsable'),(22,6,'Technicienne'),
(23,1,'Chanteur'),(23,2,'Chanteuse'),(23,3,'Musicien'),(23,4,'Musicienne'),(23,5,'Responsable'),(23,6,'Technicienne');

-- Table sortie_etat
CREATE TABLE sortie_etat (
    id_sortie_etat SERIAL PRIMARY KEY,
    id_sortie INT NOT NULL,
    id_etat INT NOT NULL,
    date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sortie) REFERENCES sortie(id_sortie) ON DELETE CASCADE,
    FOREIGN KEY (id_etat)   REFERENCES etat(id_etat)
);

INSERT INTO sortie_etat (id_sortie, id_etat, date_changement) VALUES
(1,1,NOW()),(2,1,NOW()),(3,1,NOW()),(4,1,NOW()),(5,1,NOW()),(6,1,NOW()),(7,1,NOW()),(8,1,NOW()),
(9,1,NOW()),(10,1,NOW()),(11,1,NOW()),(12,1,NOW()),(13,1,NOW()),(14,1,NOW()),(15,1,NOW()),
(16,1,NOW()),(17,1,NOW()),(18,1,NOW()),(19,1,NOW()),(20,1,NOW()),(21,1,NOW()),(22,1,NOW()),(23,1,NOW());

-- Table media_archive
CREATE TABLE media_archive (
    id_media SERIAL PRIMARY KEY,
    id_sortie INT,
    type_media VARCHAR(20) CHECK (type_media IN ('photo','video','affiche','document')) NOT NULL,
    fichier_path VARCHAR(255) NOT NULL,
    fichier_nom_original VARCHAR(255),
    taille_fichier INT,
    format_fichier VARCHAR(10),
    description TEXT,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ordre_affichage INT DEFAULT 0,
    actif BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_sortie) REFERENCES sortie(id_sortie) ON DELETE SET NULL
);
CREATE INDEX idx_media_archive_type ON media_archive (type_media);

INSERT INTO media_archive (id_sortie, type_media, fichier_path, fichier_nom_original, taille_fichier, format_fichier, description, ordre_affichage, actif) VALUES
(1,'photo',  '/media/photos/metm_avaradoha.jpg',   'metm_avaradoha.jpg',   2048,    'jpg', 'Photo de METM Avaradoha',  1, TRUE),
(1,'video',  '/media/videos/metm_avaradoha.mp4',   'metm_avaradoha.mp4',   1048576, 'mp4', 'Vidéo de METM Avaradoha',  2, TRUE),
(1,'affiche','/media/affiches/metm_avaradoha.pdf', 'metm_avaradoha.pdf',   512,     'pdf', 'Affiche METM Avaradoha',   3, TRUE),
(2,'photo',  '/media/photos/fpvm_talatanivolonondry.jpg',  'fpvm_talatanivolonondry.jpg',  2048,    'jpg', 'Photo de FPVM Talatanivolonondry',  1, TRUE),
(2,'video',  '/media/videos/fpvm_talatanivolonondry.mp4',  'fpvm_talatanivolonondry.mp4',  1048576, 'mp4', 'Vidéo de FPVM Talatanivolonondry',  2, TRUE),
(2,'affiche','/media/affiches/fpvm_talatanivolonondry.pdf','fpvm_talatanivolonondry.pdf',  512,     'pdf', 'Affiche FPVM Talatanivolonondry',   3, TRUE),
(3,'photo',  '/media/photos/fjkm_antanibe_fiainana_arivonimamo.jpg',  'fjkm_antanibe_fiainana_arivonimamo.jpg',  2048,    'jpg','Photo de FJKM Antanibe Fiainana Arivonimamo', 1, TRUE),
(3,'video',  '/media/videos/fjkm_antanibe_fiainana_arivonimamo.mp4',  'fjkm_antanibe_fiainana_arivonimamo.mp4',  1048576, 'mp4','Vidéo de FJKM Antanibe Fiainana Arivonimamo', 2, TRUE),
(3,'affiche','/media/affiches/fjkm_antanibe_fiainana_arivonimamo.pdf','fjkm_antanibe_fiainana_arivonimamo.pdf',  512,     'pdf','Affiche FJKM Antanibe Fiainana Arivonimamo',  3, TRUE),
(22,'photo', '/media/photos/fpvm_carion.jpg',  'fpvm_carion.jpg',  2048,    'jpg', 'Photo de FPVM Carion', 1, TRUE),
(22,'video', '/media/videos/fpvm_carion.mp4',  'fpvm_carion.mp4',  1048576, 'mp4', 'Vidéo de FPVM Carion', 2, TRUE),
(22,'affiche','/media/affiches/fpvm_carion.pdf','fpvm_carion.pdf', 512,     'pdf', 'Affiche FPVM',         3, TRUE),
(23,'photo', '/media/photos/fpvm_carion.jpg',  'fpvm_carion.jpg',  2048,    'jpg', 'Photo de FPVM Carion', 1, TRUE),
(23,'video', '/media/videos/fpvm_carion.mp4',  'fpvm_carion.mp4',  1048576, 'mp4', 'Vidéo de FPVM Carion', 2, TRUE),
(23,'affiche','/media/affiches/fpvm_carion.pdf','fpvm_carion.pdf', 512,     'pdf', 'Affiche FPVM Carion',  3, TRUE);

-- Table photo_sortie
CREATE TABLE photo_sortie (
    id_photo_sortie SERIAL PRIMARY KEY,
    id_sortie INT,
    id_photo INT,
    date_sortie DATE,
    FOREIGN KEY (id_sortie) REFERENCES sortie(id_sortie),
    FOREIGN KEY (id_photo)  REFERENCES photo(id_photo)
);

INSERT INTO photo_sortie (id_sortie, id_photo, date_sortie) VALUES
(1,1,'2024-10-27'),(2,2,'2024-11-24'),(3,3,'2024-12-08'),(4,4,'2025-04-06'),(5,5,'2025-04-27'),
(6,6,'2025-05-03'),(7,7,'2025-05-04'),(8,8,'2025-05-11'),(9,9,'2025-05-18'),(10,10,'2025-05-24'),
(11,11,'2025-06-22'),(12,12,'2025-07-06'),(13,13,'2025-07-12'),(14,14,'2025-07-20'),(15,15,'2025-07-27'),
(16,16,'2025-08-02'),(17,17,'2025-08-03'),(18,18,'2025-08-10'),(19,19,'2025-08-24'),(20,20,'2025-08-31'),
(21,21,'2025-09-14'),(22,22,'2025-10-26'),(23,23,'2025-11-09');

-- =============================================
-- 6. TABLES DÉPENDANTES DU NIVEAU 4
-- =============================================

-- Table notification
CREATE TABLE notification (
    id_notification SERIAL PRIMARY KEY,
    id_reservation INT,
    id_sortie INT,
    destinataire VARCHAR(100),
    message TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type_notification VARCHAR(50),
    envoye BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation),
    FOREIGN KEY (id_sortie)      REFERENCES sortie(id_sortie)
);

INSERT INTO notification (id_reservation, id_sortie, destinataire, message, type_notification, envoye) VALUES
(1,1,NULL,'La réservation pour METM Avaradoha a été confirmée.','confirmation',FALSE),
(2,2,NULL,'La réservation pour FPVM Talatanivolonondry a été confirmée.','confirmation',FALSE),
(3,3,NULL,'La réservation pour FJKM Antanibe Fiainana Arivonimamo a été confirmée.','confirmation',FALSE),
(4,4,NULL,'La réservation pour FJKM Ziona Vaovao Tsarahonenana Imerintsiatosika a été confirmée.','confirmation',FALSE),
(5,5,NULL,'La réservation pour FJKM Ambavahadi Tokana Itaosy a été confirmée.','confirmation',FALSE),
(6,6,NULL,'La réservation pour Spectacle EXO Antsahamanitra a été confirmée.','confirmation',FALSE),
(7,7,NULL,'La réservation pour FJKM Ikanja Fiderana Arivonimamo a été confirmée.','confirmation',FALSE),
(8,8,NULL,'La réservation pour FJKM Tranovato Isoamanangano a été confirmée.','confirmation',FALSE),
(9,9,NULL,'La réservation pour FJKM Antanibe Fiainana Arivonimamo a été confirmée.','confirmation',FALSE),
(10,10,NULL,'La réservation pour FPVM Ambohimahitsy a été confirmée.','confirmation',FALSE),
(11,11,NULL,'La réservation pour FLM Ambatonjara Bypass a été confirmée.','confirmation',FALSE),
(12,12,NULL,'La réservation pour FJKM Ambatonakanga a été confirmée.','confirmation',FALSE),
(13,13,NULL,'La réservation pour FPVM Alarobia Ambatomanga a été confirmée.','confirmation',FALSE),
(14,14,NULL,'La réservation pour METM Ambohidahy Ankadidramamy a été confirmée.','confirmation',FALSE),
(15,15,NULL,'La réservation pour Astauriat Antanimena a été confirmée.','confirmation',FALSE),
(16,16,NULL,'La réservation pour FJKM Ziona Famonjena Imerintsiatosika a été confirmée.','confirmation',FALSE),
(17,17,NULL,'La réservation pour FJKM Lazaina a été confirmée.','confirmation',FALSE),
(18,18,NULL,'La réservation pour Havoria Anosy a été confirmée.','confirmation',FALSE),
(19,19,NULL,'La réservation pour FPVM Soavimasoandro a été confirmée.','confirmation',FALSE),
(20,20,NULL,'La réservation pour FJKM Ambohimandroso Ambatondrazaka a été confirmée.','confirmation',FALSE),
(21,21,NULL,'La réservation pour FPVM Ambohimanarina a été confirmée.','confirmation',FALSE),
(22,22,NULL,'La réservation pour FPVM Carion a été confirmée.','confirmation',FALSE),
(23,23,NULL,'La réservation pour FPVM Carion a été confirmée.','confirmation',FALSE);
SELECT setval('notification_id_notification_seq', 23);

-- Table publication_facebook
CREATE TABLE publication_facebook (
    id_publication SERIAL PRIMARY KEY,
    id_sortie INT,
    message_poste TEXT,
    url_media VARCHAR(500),
    date_publication TIMESTAMP,
    statut VARCHAR(10) CHECK (statut IN ('programme','publie','echec')) DEFAULT 'programme',
    message_erreur TEXT,
    id_post_facebook VARCHAR(100),
    FOREIGN KEY (id_sortie) REFERENCES sortie(id_sortie)
);

INSERT INTO publication_facebook (id_sortie, message_poste, url_media, date_publication, statut) VALUES
(1, 'Ne manquez pas notre live à METM Avaradoha !', '/media/photos/metm_avaradoha.jpg', '2024-10-27 18:00:00', 'programme'),
(2, 'Rejoignez-nous à FPVM Talatanivolonondry pour un moment de louange.', '/media/photos/fpvm_talatanivolonondry.jpg', '2024-11-24 18:00:00', 'programme'),
(3, 'Venez célébrer à FJKM Antanibe Fiainana Arivonimamo.', '/media/photos/fjkm_antanibe_fiainana_arivonimamo.jpg', '2024-12-08 18:00:00', 'programme'),
(22, 'FPVM Carion : rejoignez-nous pour le live.', '/media/photos/fpvm_carion.jpg', '2025-10-26 18:00:00', 'programme'),
(23, 'FPVM Carion : dernier live de la série, soyez nombreux !', '/media/photos/fpvm_carion.jpg', '2025-11-09 18:00:00', 'programme');

-- Table notification_statut
CREATE TABLE notification_statut (
    id_notification_statut SERIAL PRIMARY KEY,
    id_notification INT,
    id_statut_envoi INT,
    date_changement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_notification)  REFERENCES notification(id_notification) ON DELETE CASCADE,
    FOREIGN KEY (id_statut_envoi)  REFERENCES statut_envoi(id_statut_envoi)
);

INSERT INTO notification_statut (id_notification, id_statut_envoi, date_changement)
SELECT id_notification, 1, NOW() FROM notification;

-- =============================================
-- 7. VUES
-- =============================================

-- NOTE: GROUP_CONCAT (MySQL) → string_agg (PostgreSQL)
CREATE VIEW vue_sorties_completes AS
SELECT
    s.id_sortie,
    s.date_sortie,
    s.description,
    r.nom_eglise,
    l.nom_lieu,
    e.nom_etat,
    string_agg(DISTINCT (m.nom || ' ' || COALESCE(m.prenom,'')) , ', ') AS membres
FROM sortie s
    LEFT JOIN reservation r    ON s.id_reservation = r.id_reservation
    LEFT JOIN lieu l           ON s.id_lieu = l.id_lieu
    LEFT JOIN etat e           ON s.id_etat = e.id_etat
    LEFT JOIN sortie_membres sm ON s.id_sortie = sm.id_sortie
    LEFT JOIN membres m        ON sm.id_membre = m.id_membre
GROUP BY s.id_sortie, s.date_sortie, s.description, r.nom_eglise, l.nom_lieu, e.nom_etat;

CREATE VIEW vue_chansons_avec_medias AS
SELECT
    c.id_chanson,
    c.titre,
    c.auteur,
    c.genre,
    string_agg(
        mc.type_media || ':' || COALESCE(mc.url_externe, mc.fichier_path),
        ' | '
    ) AS medias
FROM chanson c
    LEFT JOIN media_chanson mc ON c.id_chanson = mc.id_chanson AND mc.actif = TRUE
GROUP BY c.id_chanson, c.titre, c.auteur, c.genre;

-- =============================================
-- FIN : Base vdfi_mpihira créée avec succès !
-- =============================================

