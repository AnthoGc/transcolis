-- ============================================================
--   Nom de la base   :  transcolis_db                            
--   Nom de SGBD      :  MySql                      
--   Date de création :  Mai 2023
--   Créateurs : Anthony GJIDARA & Njee HETTIARACHCHI
-- ============================================================

-- **************************************************************************
-- Creation de la Base de donnees transcolis_db

DROP DATABASE IF EXISTS transcolis_db;
CREATE DATABASE transcolis_db;

USE transcolis_db;

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
drop table if exists Horraire;
drop table if exists PaiementPointRelais;
drop table if exists Departement;
drop table if exists Contrat;
drop table if exists Colis;
drop table if exists SuiviColis;
drop table if exists ClientEnvoieColis;
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
   ID_PointRelais VARCHAR(50),
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

-- Structure de la table Horraire

CREATE TABLE Horraire(
   ID_Horraire VARCHAR(50),
   HeureOuverture TIME,
   HeureFermeture VARCHAR(50),
   Etat VARCHAR(50),
   ID_PointRelais VARCHAR(50),
   PRIMARY KEY(ID_Horraire),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais)
);

-- Structure de la table PaiementPointRelais

CREATE TABLE PaiementPointRelais(
   ID_Paiement VARCHAR(50),
   DatePaiement DATE,
   Montant VARCHAR(50),
   ID_PointRelais VARCHAR(50),
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
   ID_Facture VARCHAR(50),
   ID_Client VARCHAR(50),
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
   ID_Facture VARCHAR(50),
   ID_PointRelais_Expedition VARCHAR(50),
   PRIMARY KEY(ID_Colis),
   FOREIGN KEY(ID_PointRelais_Reception) REFERENCES PointRelais(ID_PointRelais) ON DELETE SET NULL,
   FOREIGN KEY(ID_PointRelais_Expedition) REFERENCES PointRelais(ID_PointRelais) ON DELETE SET NULL,
   FOREIGN KEY(ID_Destinataire) REFERENCES Destinataire(ID_Destinataire),
   FOREIGN KEY(ID_Facture) REFERENCES Facture(ID_Facture)
);

-- Strcuture de la table SuiviColis

CREATE TABLE SuiviColis(
   ID_Suivi VARCHAR(50),
   DateHeureMouvement DATETIME,
   PositionGPS TEXT,
   EtatDeLivraison VARCHAR(50),
   ID_PointRelais VARCHAR(50),
   ID_Livreur VARCHAR(50),
   ID_Colis VARCHAR(50),
   PRIMARY KEY(ID_Suivi),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais),
   FOREIGN KEY(ID_Livreur) REFERENCES Livreur(ID_Livreur),
   FOREIGN KEY(ID_Colis) REFERENCES Colis(ID_Colis)
);

-- Structure de la table ClientEnvoieColis

CREATE TABLE ClientEnvoieColis(
   ID_Client VARCHAR(50),
   ID_Colis VARCHAR(50),
   PRIMARY KEY(ID_Client, ID_Colis),
   FOREIGN KEY(ID_Client) REFERENCES Client(ID_Client),
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

-- Insertion des données pour la table Client

INSERT INTO Client VALUES 
('CL01', 'Client1', 'RS01', '123 Rue du Paradis, Paris', '0123456789'),
('CL02', 'Client2', 'RS02', '456 Boulevard de la République, Lyon', '0234567891'),
('CL03', 'Client3', 'RS03', '789 Avenue de la Paix, Marseille', '0345678921'),
('CL04', 'Client4', 'RS04', '321 Rue des Lilas, Lille', '0456789213'),
('CL05', 'Client5', 'RS05', '654 Rue du Moulin, Bordeaux', '0567892134'),
('CL06', 'Client6', 'RS06', '987 Boulevard des Écoles, Toulouse', '0678921345'),
('CL07', 'Client7', 'RS07', '234 Rue de la Soie, Nantes', '0789213456'),
('CL08', 'Client8', 'RS08', '567 Avenue de la Gare, Strasbourg', '0892134567'),
('CL09', 'Client9', 'RS09', '890 Rue des Étoiles, Montpellier', '0912345678'),
('CL10', 'Client10', 'RS10', '345 Boulevard du Parc, Nice', '1023456789');

-- Insertion des données pour la table PointRelais

INSERT INTO PointRelais VALUES
('PR01', 'PointRelais1', 'NR01', 'Responsable1', '123 Rue du Paradis, Paris', '1123456789'),
('PR02', 'PointRelais2', 'NR02', 'Responsable2', '456 Boulevard de la République, Lyon', '1234567891'),
('PR03', 'PointRelais3', 'NR03', 'Responsable3', '789 Avenue de la Paix, Marseille', '1345678921'),
('PR04', 'PointRelais4', 'NR04', 'Responsable4', '321 Rue des Lilas, Lille', '1456789213'),
('PR05', 'PointRelais5', 'NR05', 'Responsable5', '654 Rue du Moulin, Bordeaux', '1567892134'),
('PR06', 'PointRelais6', 'NR06', 'Responsable6', '987 Boulevard des Écoles, Toulouse', '1678921345'),
('PR07', 'PointRelais7', 'NR07', 'Responsable7', '234 Rue de la Soie, Nantes', '1789213456'),
('PR08', 'PointRelais8', 'NR08', 'Responsable8', '567 Avenue de la Gare, Strasbourg', '1892134567'),
('PR09', 'PointRelais9', 'NR09', 'Responsable9', '890 Rue des Étoiles, Montpellier', '1912345678'),
('PR10', 'PointRelais10', 'NR10', 'Responsable10', '345 Boulevard du Parc, Nice', '2023456789');

-- Insertion des données pour la table Livreur

INSERT INTO Livreur VALUES 
('LV01', 'Livreur1', 'DP01'),
('LV02', 'Livreur2', 'DP02'),
('LV03', 'Livreur3', 'DP03'),
('LV04', 'Livreur4', 'DP04'),
('LV05', 'Livreur5', 'DP05'),
('LV06', 'Livreur6', 'DP06'),
('LV07', 'Livreur7', 'DP07'),
('LV08', 'Livreur8', 'DP08'),
('LV09', 'Livreur9', 'DP09'),
('LV10', 'Livreur10', 'DP10');

-- Insertion des données pour la table Facture

INSERT INTO Facture VALUES 
('FC01', 'Livraison standard', '150', 'Payé'),
('FC02', 'Livraison express', '200', 'Non payé'),
('FC03', 'Livraison standard', '150', 'Payé'),
('FC04', 'Livraison express', '200', 'Non payé'),
('FC05', 'Livraison standard', '150', 'Payé'),
('FC06', 'Livraison express', '200', 'Non payé'),
('FC07', 'Livraison standard', '150', 'Payé'),
('FC08', 'Livraison express', '200', 'Non payé'),
('FC09', 'Livraison standard', '150', 'Payé'),
('FC10', 'Livraison express', '200', 'Non payé');

-- Insertion des données pour la table ContratPointRelais

INSERT INTO ContratPointRelais VALUES 
('CPR01', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR01'),
('CPR02', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR02'),
('CPR03', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR03'),
('CPR04', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR04'),
('CPR05', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR05'),
('CPR06', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR06'),
('CPR07', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR07'),
('CPR08', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR08'),
('CPR09', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR09'),
('CPR10', '2023-01-01', '2023-12-31', NULL, NULL, '200', 'PR10');

-- Insertion des données pour la table Destinataire

INSERT INTO Destinataire VALUES 
('DST01', 'Destinataire1'),
('DST02', 'Destinataire2'),
('DST03', 'Destinataire3'),
('DST04', 'Destinataire4'),
('DST05', 'Destinataire5'),
('DST06', 'Destinataire6'),
('DST07', 'Destinataire7'),
('DST08', 'Destinataire8'),
('DST09', 'Destinataire9'),
('DST10', 'Destinataire10');

-- Insertion des données pour la table Adresse

INSERT INTO Adresse VALUES 
('AD01', '123', 'Rue du Paradis', 'Paris', '75001', 'Paris', 'France', 'CL01', 'DST01'),
('AD02', '456', 'Boulevard de la République', 'Lyon', '69001', 'Rhône', 'France', 'CL02', 'DST02'),
('AD03', '789', 'Avenue de la Paix', 'Marseille', '13001', 'Bouches-du-Rhône', 'France', 'CL03', 'DST03'),
('AD04', '321', 'Rue des Lilas', 'Lille', '59000', 'Nord', 'France', 'CL04', 'DST04'),
('AD05', '654', 'Rue du Moulin', 'Bordeaux', '33000', 'Gironde', 'France', 'CL05', 'DST05'),
('AD06', '987', 'Boulevard des Écoles', 'Toulouse', '31000', 'Haute-Garonne', 'France', 'CL06', 'DST06'),
('AD07', '234', 'Rue de la Soie', 'Nantes', '44000', 'Loire-Atlantique', 'France', 'CL07', 'DST07'),
('AD08', '567', 'Avenue de la Gare', 'Strasbourg', '67000', 'Bas-Rhin', 'France', 'CL08', 'DST08'),
('AD09', '890', 'Rue des Étoiles', 'Montpellier', '34000', 'Hérault', 'France', 'CL09', 'DST09'),
('AD10', '345', 'Boulevard du Parc', 'Nice', '06000', 'Alpes-Maritimes', 'France', 'CL10', 'DST10');

-- Insertion des données pour la table Horraire

INSERT INTO Horraire VALUES 
('HR01', '08:00:00', '18:00:00', 'Ouvert', 'PR01'),
('HR02', '08:00:00', '18:00:00', 'Ouvert', 'PR02'),
('HR03', '08:00:00', '18:00:00', 'Ouvert', 'PR03'),
('HR04', '08:00:00', '18:00:00', 'Ouvert', 'PR04'),
('HR05', '08:00:00', '18:00:00', 'Ouvert', 'PR05'),
('HR06', '08:00:00', '18:00:00', 'Ouvert', 'PR06'),
('HR07', '08:00:00', '18:00:00', 'Ouvert', 'PR07'),
('HR08', '08:00:00', '18:00:00', 'Ouvert', 'PR08'),
('HR09', '08:00:00', '18:00:00', 'Ouvert', 'PR09'),
('HR10', '08:00:00', '18:00:00', 'Ouvert', 'PR10');

-- Insertion des données pour la table PaiementPointRelais

INSERT INTO PaiementPointRelais VALUES 
('PPR01', '2023-02-01', '200', 'PR01'),
('PPR02', '2023-02-01', '200', 'PR02'),
('PPR03', '2023-02-01', '200', 'PR03'),
('PPR04', '2023-02-01', '200', 'PR04'),
('PPR05', '2023-02-01', '200', 'PR05'),
('PPR06', '2023-02-01', '200', 'PR06'),
('PPR07', '2023-02-01', '200', 'PR07'),
('PPR08', '2023-02-01', '200', 'PR08'),
('PPR09', '2023-02-01', '200', 'PR09'),
('PPR10', '2023-02-01', '200', 'PR10');

-- Insertion des données pour la table Departement

INSERT INTO Departement VALUES 
('DP01', 'Paris', '75'),
('DP02', 'Rhône', '69'),
('DP03', 'Bouches-du-Rhône', '13'),
('DP04', 'Nord', '59'),
('DP05', 'Gironde', '33'),
('DP06', 'Haute-Garonne', '31'),
('DP07', 'Loire-Atlantique', '44'),
('DP08', 'Bas-Rhin', '67'),
('DP09', 'Hérault', '34'),
('DP10', 'Alpes-Maritimes', '06');

-- Insertion des données pour la table Contrat

INSERT INTO Contrat VALUES 
('CT01', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC01', 'CL01'),
('CT02', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC02', 'CL02'),
('CT03', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC03', 'CL03'),
('CT04', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC04', 'CL04'),
('CT05', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC05', 'CL05'),
('CT06', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC06', 'CL06'),
('CT07', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC07', 'CL07'),
('CT08', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC08', 'CL08'),
('CT09', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC09', 'CL09'),
('CT10', '2023-01-01', '2023-12-31', 0.2, 0.1, 0.15, 'FC10', 'CL10');

-- Insertion des données pour la table Colis

INSERT INTO Colis VALUES 
('CO01', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR01', 'DST01', 'FC01', 'PR06'),
('CO02', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR02', 'DST02', 'FC02', 'PR07'),
('CO03', 5.00, 10.00, '2023-02-01', '2023-05-20', 'Vêtements', 'PR03', 'DST03', 'FC03', 'PR08'),
('CO04', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR04', 'DST04', 'FC04', 'PR09'),
('CO05', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR05', 'DST05', 'FC05', 'PR10'),
('CO06', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR06', 'DST06', 'FC06', 'PR01'),
('CO07', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR07', 'DST07', 'FC07', 'PR02'),
('CO08', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR08', 'DST08', 'FC08', 'PR03'),
('CO09', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR09', 'DST09', 'FC09', 'PR04'),
('CO10', 5.00, 10.00, '2023-02-01', '2023-02-10', 'Vêtements', 'PR10', 'DST10', 'FC10', 'PR05');

-- Insertion des données pour la table SuiviColis

INSERT INTO SuiviColis VALUES 
('SC01', '2023-02-01 08:00:00', '48.8566,2.3522', 'En cours', 'PR01', 'LV01', 'CO01'),
('SC02', '2023-02-01 08:00:00', '45.75,4.85', 'En cours', 'PR02', 'LV02', 'CO02'),
('SC03', '2023-02-01 08:00:00', '43.2965,5.3698', 'Livre', 'PR03', 'LV03', 'CO03'),
('SC04', '2023-02-01 08:00:00', '50.6292,3.0573', 'En cours', 'PR04', 'LV04', 'CO04'),
('SC05', '2023-02-01 08:00:00', '44.8378, -0.5792', 'En cours', 'PR05', 'LV05', 'CO05'),
('SC06', '2023-02-01 08:00:00', '43.6043,1.4437', 'En cours', 'PR06', 'LV06', 'CO06'),
('SC07', '2023-02-01 08:00:00', '47.2181, -1.5534', 'En cours', 'PR07', 'LV07', 'CO07'),
('SC08', '2023-02-01 08:00:00', '48.5734,7.7521', 'En cours', 'PR08', 'LV08', 'CO08'),
('SC09', '2023-02-01 08:00:00', '43.6108,3.8767', 'En cours', 'PR09', 'LV09', 'CO09'),
('SC10', '2023-02-01 08:00:00', '43.7102,7.2620', 'En cours', 'PR10', 'LV10', 'CO10');

-- Insertion des données pour la table ClientEnvoieColis

INSERT INTO ClientEnvoieColis VALUES 
('CL01', 'CO01'),
('CL02', 'CO02'),
('CL03', 'CO03'),
('CL04', 'CO04'),
('CL05', 'CO05'),
('CL06', 'CO06'),
('CL07', 'CO07'),
('CL08', 'CO08'),
('CL09', 'CO09'),
('CL10', 'CO10');

-- Insertion des données pour la table LivreurResponsableDepartement

INSERT INTO LivreurResponsableDepartement VALUES 
('LV01', 'DP01'),
('LV02', 'DP02'),
('LV03', 'DP03'),
('LV04', 'DP04'),
('LV05', 'DP05'),
('LV06', 'DP06'),
('LV07', 'DP07'),
('LV08', 'DP08'),
('LV09', 'DP09'),
('LV10', 'DP10');