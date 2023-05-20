-- ===================================================================
--   Nom de la base   :  trans_colis_db                            
--   Nom de SGBD      :  MySql                      
--   Date de création :  Mai 2023
--   Créateurs : Anthony G. & Njee H. & Jahlan E.
-- ===================================================================

-- **************************************************************************
-- Creation de la Base de donnees trans_colis_db

DROP DATABASE IF EXISTS trans_colis_db;
CREATE DATABASE trans_colis_db;

USE trans_colis_db;

-- **************************************************************************
-- 1. DROP all tables
-- Note: beware of foreign keys

drop table if exists Client;
drop table if exists PointRelais;
drop table if exists Livreur;
drop table if exists Facture;
drop table if exists ContratPointRelais;
drop table if exists Destinataire;
drop table if exists Adresse;
drop table if exists Horaire;
drop table if exists PaiementPointRelais;
drop table if exists Departement;
drop table if exists Contrat;
drop table if exists Colis;
drop table if exists SuiviColis;
drop table if exists LivreurResponsableDepartement;

-- **************************************************************************
-- 2. CREATE TABLES 

-- Force MySQL to comply with standard
-- SQL regarding "group by"

set session sql_mode = 'ONLY_FULL_GROUP_BY';

-- Structure de la table Client

CREATE TABLE Client(
   ID_Client VARCHAR(50),
   RaisonSociale VARCHAR(50),
   NumRegistre VARCHAR(50),
   AdresseSiegeSocial VARCHAR(255),
   Telephone VARCHAR(10),
   PRIMARY KEY(ID_Client)
);

-- Structure de la table PointRelais

CREATE TABLE PointRelais(
   ID_PointRelais VARCHAR(50),
   RaisonSociale VARCHAR(50),
   NumRegistre VARCHAR(50),
   NomResponsable VARCHAR(50),
   Adresse VARCHAR(50),
   Telephone VARCHAR(10),
   PRIMARY KEY(ID_PointRelais)
);

-- Structure de la table Livreur

CREATE TABLE Livreur(
   ID_Livreur VARCHAR(50),
   Nom VARCHAR(50),
   DepartementResponsable VARCHAR(50),
   PRIMARY KEY(ID_Livreur)
);

-- Structure de la table Facture

CREATE TABLE Facture(
   ID_Facture VARCHAR(50),
   TypeLivraison VARCHAR(50),
   Total VARCHAR(50),
   Etat VARCHAR(50),
   PRIMARY KEY(ID_Facture)
);

-- Structure de la table ContratPointRelais

CREATE TABLE ContratPointRelais(
   ID_ContratPointRelais VARCHAR(50),
   DateDebut DATE,
   DateFin DATE,
   DateNotificationResiliation DATE,
   DateEffectiveResiliation DATE,
   TarifPointRelais VARCHAR(50),
   ID_PointRelais VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_ContratPointRelais),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais)
);

-- Structure de la table Destinataire

CREATE TABLE Destinataire(
   ID_Destinataire VARCHAR(50),
   NomDestinataire VARCHAR(50),
   PRIMARY KEY(ID_Destinataire)
);

-- Structure de la table Adresse

CREATE TABLE Adresse(
   ID_Adresse VARCHAR(50),
   Numero VARCHAR(50),
   Rue VARCHAR(50),
   Ville VARCHAR(50),
   CodePostal VARCHAR(50),
   Departement VARCHAR(50),
   Pays VARCHAR(50),
   ID_Client VARCHAR(50),
   ID_Destinataire VARCHAR(50),
   PRIMARY KEY(ID_Adresse),
   FOREIGN KEY(ID_Client) REFERENCES Client(ID_Client),
   FOREIGN KEY(ID_Destinataire) REFERENCES Destinataire(ID_Destinataire)
);

-- Structure de la table Horaire

CREATE TABLE Horaire(
   ID_Horaire VARCHAR(50),
   HeureOuverture TIME,
   HeureFermeture VARCHAR(50),
   Etat VARCHAR(50),
   ID_PointRelais VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_Horaire),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais)
);

-- Structure de la table PaiementPointRelais

CREATE TABLE PaiementPointRelais(
   ID_Paiement VARCHAR(50),
   DatePaiement DATE,
   Montant VARCHAR(50),
   ID_PointRelais VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_Paiement),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais)
);

-- Structure de la table Departement

CREATE TABLE Departement(
   ID_Departement VARCHAR(50),
   NomDepartement VARCHAR(50),
   NumDepartement VARCHAR(50),
   PRIMARY KEY(ID_Departement)
);

-- Structure de la table Contrat

CREATE TABLE Contrat(
   ID_Contrat VARCHAR(50),
   DateDebut DATE,
   DateFin DATE,
   CoefPoids DECIMAL(7,2),
   CoefTaille DECIMAL(7,2),
   CoefPointRelais DECIMAL(7,2),
   ID_Facture VARCHAR(50) NOT NULL,
   ID_Client VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_Contrat),
   FOREIGN KEY(ID_Facture) REFERENCES Facture(ID_Facture),
   FOREIGN KEY(ID_Client) REFERENCES Client(ID_Client)
);

-- Structure de la table Colis

CREATE TABLE Colis(
   ID_Colis VARCHAR(50),
   Poids DECIMAL(5,2),
   Taille DECIMAL(5,2),
   DatePriseEnCharge DATE,
   DateLivraison DATE,
   Contenu VARCHAR(255),
   ID_PointRelais_Reception VARCHAR(50),
   ID_Destinataire VARCHAR(50),
   ID_Facture VARCHAR(50) NOT NULL,
   ID_PointRelais_Expedition VARCHAR(50),
   ID_Client VARCHAR(50),
   PRIMARY KEY(ID_Colis),
   FOREIGN KEY(ID_PointRelais_Reception) REFERENCES PointRelais(ID_PointRelais),
   FOREIGN KEY(ID_Destinataire) REFERENCES Destinataire(ID_Destinataire),
   FOREIGN KEY(ID_Facture) REFERENCES Facture(ID_Facture),
   FOREIGN KEY(ID_PointRelais_Expedition) REFERENCES PointRelais(ID_PointRelais),
   FOREIGN KEY(ID_Client) REFERENCES Client(ID_Client)
);

-- Structure de la table SuiviColis

CREATE TABLE SuiviColis(
   ID_Suivi VARCHAR(50),
   DateHeureMouvement DATETIME,
   PositionGPS TEXT,
   EtatDeLivraison VARCHAR(50),
   ID_PointRelais VARCHAR(50),
   ID_Livreur VARCHAR(50),
   ID_Colis VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_Suivi),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais),
   FOREIGN KEY(ID_Livreur) REFERENCES Livreur(ID_Livreur),
   FOREIGN KEY(ID_Colis) REFERENCES Colis(ID_Colis)
);

-- Structure de la table LivreurResponsableDepartement

CREATE TABLE LivreurResponsableDepartement(
   ID_Livreur VARCHAR(50),
   ID_Departement VARCHAR(50),
   PRIMARY KEY(ID_Livreur, ID_Departement),
   FOREIGN KEY(ID_Livreur) REFERENCES Livreur(ID_Livreur),
   FOREIGN KEY(ID_Departement) REFERENCES Departement(ID_Departement)
);

-- **************************************************************************
-- 3. POPULATE database

-- Remplir la table Client

INSERT INTO Client(ID_Client, RaisonSociale, NumRegistre, AdresseSiegeSocial, Telephone) VALUES
('CLIE01', 'Amazon France Services SAS', 'Registre01', '67 Boulevard du Général Leclerc, 92110 Clichy', '1234567890'),
('CLIE02', 'LDLC.com', 'Registre02', '12 Rue Jules Verne, 69100 Villeurbanne', '0987654321'),
('CLIE03', 'Airbus SE', 'Registre03', '1 Rond-Point Maurice Bellonte, 31707 Blagnac Cedex', '1231231230'),
('CLIE04', 'Orange SA', 'Registre04', '78 Rue Olivier de Serres, 75015 Paris', '3213213210'),
('CLIE05', 'Carrefour SA', 'Registre05', '33 Avenue Émile Zola, 92100 Boulogne-Billancourt', '9879879870'),
('CLIE06', 'Google LLC', 'Registre06', '8 Rue de Londres, 75009 Paris', '7897897890'),
('CLIE07', 'Renault S.A.', 'Registre07', '13-15 Quai le Gallo, 92100 Boulogne-Billancourt', '4564564560'),
('CLIE08', 'Danone S.A.', 'Registre08', '17 Boulevard Haussmann, 75009 Paris', '6546546540'),
('CLIE09', 'Sanofi S.A.', 'Registre09', '54 Rue La Boétie, 75008 Paris', '8528528520'),
('CLIE10', 'Air France-KLM', 'Registre10', '45 Rue de Paris, 95747 Roissy Charles de Gaulle Cedex', '2582582580');

-- Remplir la table PointRelais

INSERT INTO PointRelais(ID_PointRelais, RaisonSociale, NumRegistre, NomResponsable, Adresse, Telephone) VALUES
('PORE01', 'Relais Colis', 'Registre01', 'John Smith', '12 Rue de la Paix, 75002 Paris', '1234567890'),
('PORE02', 'Mondial Relay', 'Registre02', 'Emma Johnson', '15 Rue du Commerce, 69002 Lyon', '0987654321'),
('PORE03', 'UPS Access Point', 'Registre03', 'Michael Garcia', '8 Boulevard de la Liberté, 13001 Marseille', '1231231230'),
('PORE04', 'La Poste', 'Registre04', 'Sophie Martin', '18 Rue des Halles, 75001 Paris', '3213213210'),
('PORE05', 'DPD Pickup', 'Registre05', 'David Dupont', '25 Avenue Charles de Gaulle, 92100 Boulogne-Billancourt', '9879879870'),
('PORE06', 'Chronopost Pickup', 'Registre06', 'Laura Dubois', '6 Place de la République, 59000 Lille', '7897897890'),
('PORE07', 'DHL Service Point', 'Registre07', 'Thomas Wilson', '14 Rue des Lombards, 33000 Bordeaux', '4564564560'),
('PORE08', 'FedEx Drop-off', 'Registre08', 'Julie Anderson', '21 Rue de la Paix, 06000 Nice', '6546546540'),
('PORE09', 'GLS Point Relais', 'Registre09', 'Pauline Robert', '9 Avenue Jean Jaurès, 31000 Toulouse', '8528528520'),
('PORE10', 'TNT Relais', 'Registre10', 'Alexandre Petit', '27 Rue des Arts, 59000 Lille', '2582582580'),
('PORE11', 'Colissimo Point Retrait', 'Registre11', 'Sophie Laurent', '5 Place Bellecour, 69002 Lyon', '2582582580');

-- Remplir la table Livreur

INSERT INTO Livreur(ID_Livreur, Nom, DepartementResponsable) VALUES
('LIVR01', 'Livreur01', 'Departement01'),
('LIVR02', 'Livreur02', 'Departement02'),
('LIVR03', 'Livreur03', 'Departement03'),
('LIVR04', 'Livreur04', 'Departement04'),
('LIVR05', 'Livreur05', 'Departement05'),
('LIVR06', 'Livreur06', 'Departement06'),
('LIVR07', 'Livreur07', 'Departement07'),
('LIVR08', 'Livreur08', 'Departement08'),
('LIVR09', 'Livreur09', 'Departement09'),
('LIVR10', 'Livreur10', 'Departement10');

-- Remplir la table Facture

INSERT INTO Facture(ID_Facture, TypeLivraison, Total, Etat) VALUES
('FACT01', 'PR-PR', '100.00', 'Paye'),
('FACT02', 'A-PR', '120.00', 'Paye'),
('FACT03', 'PR-A', '130.00', 'Non-Paye'),
('FACT04', 'A-A', '110.00', 'Paye'),
('FACT05', 'PR-PR', '140.00', 'Non-Paye'),
('FACT06', 'A-PR', '150.00', 'Paye'),
('FACT07', 'PR-A', '160.00', 'Non-Paye'),
('FACT08', 'A-A', '170.00', 'Paye'),
('FACT09', 'PR-PR', '180.00', 'Non-Paye'),
('FACT10', 'A-PR', '190.00', 'Paye');

-- Remplir la table ContratPointRelais

INSERT INTO ContratPointRelais(ID_ContratPointRelais, DateDebut, DateFin, DateNotificationResiliation, DateEffectiveResiliation, TarifPointRelais, ID_PointRelais) VALUES
('CONP01', '2022-01-01', '2023-01-01', '2022-12-01', '2023-01-01', '50.00', 'PORE01'),
('CONP02', '2022-02-01', '2023-02-01', '2022-12-01', '2023-02-01', '55.00', 'PORE02'),
('CONP03', '2022-03-01', '2023-03-01', '2022-12-01', '2023-03-01', '60.00', 'PORE03'),
('CONP04', '2022-04-01', '2023-04-01', '2022-12-01', '2023-04-01', '65.00', 'PORE04'),
('CONP05', '2022-05-01', '2023-05-01', '2022-12-01', '2023-05-01', '70.00', 'PORE05'),
('CONP06', '2022-06-01', '2023-06-01', '2022-12-01', '2023-06-01', '75.00', 'PORE06'),
('CONP07', '2022-07-01', '2023-07-01', '2022-12-01', '2023-07-01', '80.00', 'PORE07'),
('CONP08', '2022-08-01', '2023-08-01', '2022-12-01', '2023-08-01', '85.00', 'PORE08'),
('CONP09', '2022-09-01', '2023-09-01', '2022-12-01', '2023-09-01', '90.00', 'PORE09'),
('CONP10', '2022-10-01', '2023-10-01', '2022-12-01', '2023-10-01', '95.00', 'PORE10');

-- Remplir la table Destinataire

INSERT INTO Destinataire(ID_Destinataire, NomDestinataire) VALUES
('DEST01', 'Destinataire01'),
('DEST02', 'Destinataire02'),
('DEST03', 'Destinataire03'),
('DEST04', 'Destinataire04'),
('DEST05', 'Destinataire05'),
('DEST06', 'Destinataire06'),
('DEST07', 'Destinataire07'),
('DEST08', 'Destinataire08'),
('DEST09', 'Destinataire09'),
('DEST10', 'Destinataire10');

-- Remplir la table Adresse

INSERT INTO Adresse(ID_Adresse, Numero, Rue, Ville, CodePostal, Departement, Pays, ID_Client, ID_Destinataire) VALUES
('ADRE01', '12', 'Rue de la Paix', 'Paris', '75001', '75', 'France', 'CLIE01', NULL),
('ADRE02', '25', 'Avenue des Champs-Élysées', 'Paris', '75008', '75', 'France', 'CLIE02', NULL),
('ADRE03', '8', 'Rue du Faubourg Saint-Honoré', 'Paris', '75008', '75', 'France', 'CLIE03', NULL),
('ADRE04', '42', 'Rue de Rivoli', 'Paris', '75004', '75', 'France', 'CLIE04', NULL),
('ADRE05', '16', 'Avenue de la Grande Armée', 'Paris', '75017', '75', 'France', 'CLIE05', NULL),
('ADRE06', '6', 'Place de la Concorde', 'Paris', '75008', '75', 'France', 'CLIE06', NULL),
('ADRE07', '10', 'Rue des Lombards', 'Paris', '75004', '75', 'France', 'CLIE07', NULL),
('ADRE08', '75', 'Avenue des Gobelins', 'Paris', '75013', '75', 'France', 'CLIE08', NULL),
('ADRE09', '21', 'Boulevard Haussmann', 'Paris', '75009', '75', 'France', 'CLIE09', NULL),
('ADRE10', '5', 'Rue de Rennes', 'Paris', '75006', '75', 'France', 'CLIE10', NULL),
('ADRE11', '18', 'Rue de la République', 'Marseille', '13001', '13', 'France', NULL, 'DEST01'),
('ADRE12', '9', 'Avenue Jean Jaurès', 'Toulouse', '31000', '31', 'France', NULL, 'DEST02'),
('ADRE13', '3', 'Rue du Port', 'Nantes', '44000', '44', 'France', NULL, 'DEST03'),
('ADRE14', '27', 'Rue de la Liberté', 'Lyon', '69001', '69', 'France', NULL, 'DEST04'),
('ADRE15', '14', 'Place Bellecour', 'Lyon', '69002', '69', 'France', NULL, 'DEST05'),
('ADRE16', '2', 'Rue de la Paix', 'Nice', '06000', '06', 'France', NULL, 'DEST06'),
('ADRE17', '21', 'Avenue de la République', 'Bordeaux', '33000', '33', 'France', NULL, 'DEST07'),
('ADRE18', '11', 'Rue Sainte-Catherine', 'Bordeaux', '33000', '33', 'France', NULL, 'DEST08');

-- Remplir la table Horaire

INSERT INTO Horaire(ID_Horaire, HeureOuverture, HeureFermeture, Etat, ID_PointRelais) VALUES
('HORA01', '08:00:00', '18:00:00', 'Actif', 'PORE01'),
('HORA02', '09:00:00', '19:00:00', 'Actif', 'PORE02'),
('HORA03', '08:00:00', '18:00:00', 'Actif', 'PORE03'),
('HORA04', '08:00:00', '18:00:00', 'Actif', 'PORE04'),
('HORA05', '09:00:00', '19:00:00', 'Actif', 'PORE05'),
('HORA06', '08:00:00', '18:00:00', 'Actif', 'PORE06'),
('HORA07', '09:00:00', '19:00:00', 'Actif', 'PORE07'),
('HORA08', '08:00:00', '18:00:00', 'Actif', 'PORE08'),
('HORA09', '08:00:00', '18:00:00', 'Actif', 'PORE09'),
('HORA10', '09:00:00', '19:00:00', 'Actif', 'PORE10');

-- Remplir la table PaiementPointRelais

INSERT INTO PaiementPointRelais(ID_Paiement, DatePaiement, Montant, ID_PointRelais) VALUES
('PAIE01', '2023-01-01', '50.00', 'PORE01'),
('PAIE02', '2023-02-01', '55.00', 'PORE02'),
('PAIE03', '2023-03-01', '60.00', 'PORE03'),
('PAIE04', '2023-04-01', '65.00', 'PORE04'),
('PAIE05', '2023-05-01', '70.00', 'PORE05'),
('PAIE06', '2023-06-01', '75.00', 'PORE06'),
('PAIE07', '2023-07-01', '80.00', 'PORE07'),
('PAIE08', '2023-08-01', '85.00', 'PORE08'),
('PAIE09', '2023-09-01', '90.00', 'PORE09'),
('PAIE10', '2023-10-01', '95.00', 'PORE10');

-- Remplir la table Departement

INSERT INTO Departement(ID_Departement, NomDepartement, NumDepartement) VALUES
('DEPA01', 'Departement01', '01'),
('DEPA02', 'Departement02', '02'),
('DEPA03', 'Departement03', '03'),
('DEPA04', 'Departement04', '04'),
('DEPA05', 'Departement05', '05'),
('DEPA06', 'Departement06', '06'),
('DEPA07', 'Departement07', '07'),
('DEPA08', 'Departement08', '08'),
('DEPA09', 'Departement09', '09'),
('DEPA10', 'Departement10', '10');

-- Remplir la table Contrat

INSERT INTO Contrat(ID_Contrat, DateDebut, DateFin, CoefPoids, CoefTaille, CoefPointRelais, ID_Facture, ID_Client) VALUES
('CONT01', '2023-01-01', '2023-12-31', 1.0, 1.0, 1.0, 'FACT01', 'CLIE01'),
('CONT02', '2023-01-01', '2023-12-31', 1.1, 1.1, 1.1, 'FACT02', 'CLIE02'),
('CONT03', '2023-01-01', '2023-12-31', 1.2, 1.2, 1.2, 'FACT03', 'CLIE03'),
('CONT04', '2023-01-01', '2023-12-31', 1.3, 1.3, 1.3, 'FACT04', 'CLIE04'),
('CONT05', '2023-01-01', '2023-12-31', 1.4, 1.4, 1.4, 'FACT05', 'CLIE05'),
('CONT06', '2023-01-01', '2023-12-31', 1.5, 1.5, 1.5, 'FACT06', 'CLIE06'),
('CONT07', '2023-01-01', '2023-12-31', 1.6, 1.6, 1.6, 'FACT07', 'CLIE07'),
('CONT08', '2023-01-01', '2023-12-31', 1.7, 1.7, 1.7, 'FACT08', 'CLIE08'),
('CONT09', '2023-01-01', '2023-12-31', 1.8, 1.8, 1.8, 'FACT09', 'CLIE09'),
('CONT10', '2023-01-01', '2023-12-31', 1.9, 1.9, 1.9, 'FACT10', 'CLIE10');

-- Remplir la table Colis

INSERT INTO Colis(ID_Colis, Poids, Taille, DatePriseEnCharge, DateLivraison, Contenu, ID_PointRelais_Reception, ID_Destinataire, ID_Facture, ID_PointRelais_Expedition, ID_Client) VALUES
('COLI01', 10.00, 10.00, '2023-01-01', '2023-05-20', 'Contenu du colis 1', 'PORE01', 'DEST01', 'FACT01', 'PORE01', 'CLIE01'),
('COLI02', 15.00, 15.00, '2023-01-02', '2023-02-03', 'Contenu du colis 2', 'PORE02', 'DEST02', 'FACT02', 'PORE02', 'CLIE02'),
('COLI03', 20.00, 20.00, '2023-01-03', '2023-01-04', 'Contenu du colis 3', 'PORE03', 'DEST03', 'FACT03', 'PORE03', 'CLIE03'),
('COLI04', 25.00, 25.00, '2023-01-04', '2023-04-05', 'Contenu du colis 4', 'PORE04', 'DEST04', 'FACT04', 'PORE04', 'CLIE04'),
('COLI05', 30.00, 30.00, '2023-01-05', '2023-06-20', 'Contenu du colis 5', 'PORE05', 'DEST05', 'FACT05', 'PORE05', 'CLIE05'),
('COLI06', 35.00, 35.00, '2023-01-06', '2023-05-23', 'Contenu du colis 6', 'PORE06', 'DEST06', 'FACT06', 'PORE06', 'CLIE06'),
('COLI07', 40.00, 40.00, '2023-01-07', '2023-05-21', 'Contenu du colis 7', 'PORE07', 'DEST07', 'FACT07', 'PORE07', 'CLIE07'),
('COLI08', 45.00, 45.00, '2023-01-08', '2023-01-09', 'Contenu du colis 8', 'PORE08', 'DEST08', 'FACT08', 'PORE08', 'CLIE08'),
('COLI09', 50.00, 50.00, '2023-01-09', '2023-01-10', 'Contenu du colis 9', 'PORE09', 'DEST09', 'FACT09', 'PORE09', 'CLIE09'),
('COLI10', 55.00, 55.00, '2023-01-10', '2023-01-11', 'Contenu du colis 10', 'PORE10', 'DEST10', 'FACT10', 'PORE10', 'CLIE10');

-- Remplir la table SuiviColis

INSERT INTO SuiviColis(ID_Suivi, DateHeureMouvement, PositionGPS, EtatDeLivraison, ID_PointRelais, ID_Livreur, ID_Colis) VALUES
('SUCO01', '2023-01-01 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR01', 'COLI01'),
('SUCO02', '2023-01-02 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR02', 'COLI02'),
('SUCO03', '2023-01-03 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR03', 'COLI03'),
('SUCO04', '2023-01-04 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR04', 'COLI04'),
('SUCO05', '2023-01-05 10:00:00', '48.7863, 2.1452', 'En cours de livraison', 'PORE05', 'LIVR05', 'COLI05'),
('SUCO06', '2023-01-06 10:00:00', '48.9076, 2.1234', 'En cours de livraison', NULL, 'LIVR06', 'COLI06'),
('SUCO07', '2023-01-07 10:00:00', '48.8586, 2.5522', 'En cours de livraison', 'PORE07', 'LIVR07', 'COLI07'),
('SUCO08', '2023-01-08 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR08', 'COLI08'),
('SUCO09', '2023-01-09 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR09', 'COLI09'),
('SUCO10', '2023-01-10 10:00:00', '48.8566, 2.3522', 'Livré', NULL, 'LIVR10', 'COLI10');

-- Remplir la table LivreurResponsableDepartement

INSERT INTO LivreurResponsableDepartement(ID_Livreur, ID_Departement) VALUES
('LIVR01', 'DEPA01'),
('LIVR02', 'DEPA02'),
('LIVR03', 'DEPA03'),
('LIVR04', 'DEPA04'),
('LIVR05', 'DEPA05'),
('LIVR06', 'DEPA06'),
('LIVR07', 'DEPA07'),
('LIVR08', 'DEPA08'),
('LIVR09', 'DEPA09'),
('LIVR10', 'DEPA10');


-- **************************************************************************
-- 4. Requetes SQL

-- 1. Écrire une requête (listClientActifs) qui permet de donner la liste des clients actifs (contrat en cours de validité) avec les derniers coefficients.

SELECT c.ID_Client, c.RaisonSociale, ct.CoefPoids, ct.CoefTaille, ct.CoefPointRelais
FROM Client c
JOIN Contrat ct ON c.ID_Client = ct.ID_Client
WHERE ct.DateDebut <= CURDATE() AND ct.DateFin >= CURDATE();


-- 2. Écrire une requête (listRelaisActifs) qui permet de donner la liste des points relais actifs (contrat en cours de validité).

SELECT pr.ID_PointRelais, pr.RaisonSociale, pr.NumRegistre, pr.NomResponsable, pr.Adresse, pr.Telephone
FROM PointRelais pr
JOIN ContratPointRelais cpr ON pr.ID_PointRelais = cpr.ID_PointRelais
WHERE cpr.DateDebut <= CURDATE() AND cpr.DateFin >= CURDATE();


-- 3. Écrire une requête (listeLivraisons) qui permet d’afficher les livraisons du jour.

SELECT c.ID_Colis, c.DatePriseEnCharge, c.DateLivraison, c.Contenu, pr.RaisonSociale AS PointRelaisReception, dst.NomDestinataire
FROM Colis c
LEFT JOIN PointRelais pr ON c.ID_PointRelais_Reception = pr.ID_PointRelais
JOIN Destinataire dst ON c.ID_Destinataire = dst.ID_Destinataire
WHERE DATE(c.DateLivraison) = CURDATE();


-- 4. Écrire une requête (nbrLivraisons) qui permet d’afficher le nombre de livraisons effectuées par chaque livreur par mois.

-- Incluant les précédents mois
SELECT l.ID_Livreur, l.Nom, YEAR(c.DateLivraison) AS Annee, MONTH(c.DateLivraison) AS Mois, COUNT(*) AS NombreLivraisons
FROM Livreur l
JOIN SuiviColis sc ON l.ID_Livreur = sc.ID_Livreur
JOIN Colis c ON sc.ID_Colis = c.ID_Colis
WHERE (YEAR(c.DateLivraison) = YEAR(CURDATE()) AND MONTH(c.DateLivraison) <= MONTH(CURDATE()))
   OR (YEAR(c.DateLivraison) = YEAR(CURDATE()) - 1 AND MONTH(c.DateLivraison) > MONTH(CURDATE()))
GROUP BY l.ID_Livreur, l.Nom, Annee, Mois;

-- En faisant avec le mois actuel
SELECT l.ID_Livreur, l.Nom, MONTH(c.DateLivraison) AS Mois, COUNT(*) AS NombreLivraisons
FROM Livreur l
JOIN SuiviColis sc ON l.ID_Livreur = sc.ID_Livreur
JOIN Colis c ON sc.ID_Colis = c.ID_Colis
WHERE YEAR(c.DateLivraison) = YEAR(CURDATE()) AND MONTH(c.DateLivraison) = MONTH(CURDATE())
GROUP BY l.ID_Livreur, l.Nom, Mois;


-- 5. Écrire une requête (nbrColisRelais) qui affiche nombre de colis qui transitent par chaque point relais par mois.

SELECT pr.ID_PointRelais, pr.RaisonSociale, MONTH(c.DatePriseEnCharge) AS Mois, COUNT(*) AS NombreColis
FROM PointRelais pr
JOIN Colis c ON pr.ID_PointRelais = c.ID_PointRelais_Reception
JOIN SuiviColis s ON c.ID_Colis = s.ID_Colis
WHERE s.ID_PointRelais IS NOT NULL
GROUP BY pr.ID_PointRelais, pr.RaisonSociale, Mois;


-- 6. Écrire une requête (livraisonsEnCours) qui affiche la liste des colis en cours de livraison par livreur.

SELECT l.ID_Livreur, l.Nom, c.ID_Colis, c.DateLivraison, c.Contenu
FROM Livreur l
JOIN SuiviColis s ON l.ID_Livreur = s.ID_Livreur
JOIN Colis c ON s.ID_Colis = c.ID_Colis
WHERE s.EtatDeLivraison = 'En cours de livraison';


-- 7. Écrire une requête (attenteClient) qui affiche le nombre de colis en attente de livraison par client. Un colis est dit en attente de livraison s’il est prêt chez le client, mais pas encore retiré par le livreur (prendre aussi les cas où le client dépose lui-même les colis au point relais).

SELECT cl.ID_Client, cl.RaisonSociale, COUNT(*) AS NombreColisEnAttente
FROM Client cl
JOIN Colis c ON cl.ID_Client = c.ID_Client
LEFT JOIN SuiviColis s ON c.ID_Colis = s.ID_Colis
WHERE s.EtatDeLivraison = 'En cours de livraison' OR s.EtatDeLivraison IS NULL
GROUP BY cl.ID_Client, cl.RaisonSociale;


--> 8. Écrire une requête (avgColisTransit) qui donne le temps de transit moyen d’un colis par client.

SELECT c.ID_PointRelais_Reception, pr.RaisonSociale AS PointRelaisReception, FORMAT(AVG(TIMESTAMPDIFF(MINUTE, c.DatePriseEnCharge, c.DateLivraison))/1440, 0) AS TempsTransitMoyenEnJours
FROM Colis c
JOIN PointRelais pr ON c.ID_PointRelais_Reception = pr.ID_PointRelais
WHERE c.DatePriseEnCharge IS NOT NULL AND c.DateLivraison IS NOT NULL
GROUP BY c.ID_PointRelais_Reception, PointRelaisReception;