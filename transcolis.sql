-- ============================================================
--   Nom de la base   :  transcolis                            
--   Nom de SGBD      :  MySql                      
--   Date de création :  Mai 2023
--   Créateurs : Anthony GJIDARA & Njee HETTIARACHCHI
-- ============================================================

-- **************************************************************************
-- Creation de la Base de donnees transcolis

DROP DATABASE IF EXISTS transcolis;
CREATE DATABASE transcolis;

USE transcolis;

-- **************************************************************************
-- 1. DROP all tables
-- Note: beware of foreign keys

drop table if exists Client;
drop table if exists PointRelais;
drop table if exists Facture;
drop table if exists ContratPointRelais;
drop table if exists Colis;
drop table if exists Contrat;
drop table if exists Livreur;

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
   TarifPointRelais VARCHAR(50),
   ID_PointRelais VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_ContratPointRelais),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais)
);

-- Structure de la table Colis

CREATE TABLE Colis(
   ID_Colis VARCHAR(50),
   Poids VARCHAR(50),
   Taille VARCHAR(50),
   DatePriseEnCharge DATE,
   DateLivraison DATE,
   Contenu VARCHAR(255),
   EtatDeLivraison VARCHAR(50),
   AdresseRetrait VARCHAR(255),
   NomExpediteur VARCHAR(50),
   NomDestinataire VARCHAR(50),
   AdresseDestination VARCHAR(255),
   PositionGPS TEXT,
   ID_Facture VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_Colis),
   FOREIGN KEY(ID_Facture) REFERENCES Facture(ID_Facture)
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

-- Structure de la table Livreur

CREATE TABLE Livreur(
   ID_Livreur VARCHAR(50),
   Nom VARCHAR(50),
   DepartementResponsable VARCHAR(50),
   ID_Colis VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_Livreur),
   FOREIGN KEY(ID_Colis) REFERENCES Colis(ID_Colis)
);

-- Structure de la table Envoie

CREATE TABLE Envoie(
   ID_Client VARCHAR(50),
   ID_Colis VARCHAR(50),
   PRIMARY KEY(ID_Client, ID_Colis),
   FOREIGN KEY(ID_Client) REFERENCES Client(ID_Client),
   FOREIGN KEY(ID_Colis) REFERENCES Colis(ID_Colis)
);

-- Structure de la table Stocke

CREATE TABLE Stocke(
   ID_PointRelais VARCHAR(50),
   ID_Colis VARCHAR(50),
   PRIMARY KEY(ID_PointRelais, ID_Colis),
   FOREIGN KEY(ID_PointRelais) REFERENCES PointRelais(ID_PointRelais),
   FOREIGN KEY(ID_Colis) REFERENCES Colis(ID_Colis)
);

-- **************************************************************************
-- 3. POPULATE database

-- Remplir la table Client

INSERT INTO Client VALUES
('CLI001', 'Amazon', 'R1234', '123 rue des Amazones, Paris', '0123456789'),
('CLI002', 'LDLC', 'R2345', '234 rue de Lyon, Lyon', '0234567891'),
('CLI003', 'Rakuten', 'R3456', '345 rue des Raks, Paris', '0345678912'),
('CLI004', 'eBay', 'R4567', '456 rue de la Baye, Lyon', '0456789123'),
('CLI005', 'Alibaba', 'R5678', '567 rue des Ali, Paris', '0567891234'),
('CLI006', 'Cdiscount', 'R6789', '678 rue des Comptoirs, Lyon', '0678912345'),
('CLI007', 'Zalando', 'R7890', '789 rue des Zalas, Paris', '0789123456'),
('CLI008', 'ASOS', 'R8901', '890 rue des As, Lyon', '0891234567'),
('CLI009', 'Decathlon', 'R9012', '901 rue des Athlètes, Paris', '0912345678'),
('CLI010', 'Fnac', 'R0123', '10 rue de la Fnac, Lyon', '0101234567');

-- Remplir la table PointRelais

INSERT INTO PointRelais VALUES
('PR001', 'Relais 1', 'R1111', 'Alex', '123 rue de Paris, Paris', '1111111111'),
('PR002', 'Relais 2', 'R2222', 'Boris', '234 rue de Lyon, Lyon', '2222222222'),
('PR003', 'Relais 3', 'R3333', 'Charlie', '345 rue de Marseille, Marseille', '3333333333'),
('PR004', 'Relais 4', 'R4444', 'Doris', '456 rue de Bordeaux, Bordeaux', '4444444444'),
('PR005', 'Relais 5', 'R5555', 'Edgar', '567 rue de Nantes, Nantes', '5555555555'),
('PR006', 'Relais 6', 'R6666', 'Fedor', '678 rue de Strasbourg, Strasbourg', '6666666666'),
('PR007', 'Relais 7', 'R7777', 'Gus', '789 rue de Lille, Lille', '7777777777'),
('PR008', 'Relais 8', 'R8888', 'Harry', '890 rue de Rennes, Rennes', '8888888888'),
('PR009', 'Relais 9', 'R9999', 'Ivan', '901 rue de Toulouse, Toulouse', '9999999999'),
('PR010', 'Relais 10', 'R0000', 'Jake', '10 rue de Nice, Nice', '0000000000');

-- Remplir la table Facture

INSERT INTO Facture VALUES
('FAC001', 'Relais - Relais', '100', 'payé'),
('FAC002', 'Relais - Adresse', '200', 'payé'),
('FAC003', 'Adresse - Relais', '300', 'non payé'),
('FAC004', 'Adresse - Adresse', '400', 'non payé'),
('FAC005', 'Relais - Relais', '500', 'payé'),
('FAC006', 'Relais - Adresse', '600', 'non payé'),
('FAC007', 'Adresse - Relais', '700', 'payé'),
('FAC008', 'Adresse - Adresse', '800', 'non payé'),
('FAC009', 'Relais - Relais', '900', 'payé'),
('FAC010', 'Relais - Adresse', '1000', 'non payé');

-- Remplir la table ContratPointRelais

INSERT INTO ContratPointRelais VALUES
('CTR001', '2023-01-01', '2024-01-01', '100', 'PR001'),
('CTR002', '2023-01-02', '2024-01-02', '200', 'PR002'),
('CTR003', '2023-01-03', '2024-01-03', '300', 'PR003'),
('CTR004', '2023-01-04', '2024-01-04', '400', 'PR004'),
('CTR005', '2023-01-05', '2024-01-05', '500', 'PR005'),
('CTR006', '2023-01-06', '2024-01-06', '600', 'PR006'),
('CTR007', '2023-01-07', '2024-01-07', '700', 'PR007'),
('CTR008', '2023-01-08', '2024-01-08', '800', 'PR008'),
('CTR009', '2023-01-09', '2024-01-09', '900', 'PR009'),
('CTR010', '2023-01-10', '2024-01-10', '1000', 'PR010');

-- Remplir la table Colis

INSERT INTO Colis VALUES
('COL001', '10', '20', '2023-01-01', '2023-01-02', 'Livres', 'livré', '123 rue Paris, Paris', 'Amazon', 'Alice', '123 rue Lyon, Lyon', '48.8566,2.3522', 'FAC001'),
('COL002', '20', '30', '2023-01-02', '2023-01-03', 'Electronics', 'livré', '234 rue Lyon, Lyon', 'LDLC', 'Bob', '234 rue Paris, Paris', '45.75,4.85', 'FAC002'),
('COL003', '30', '40', '2023-01-03', '2023-01-04', 'Livres', 'non livré', '345 rue Marseille, Marseille', 'Rakuten', 'Charlie', '345 rue Lyon, Lyon', '43.2965,5.3698', 'FAC003'),
('COL004', '40', '50', '2023-01-04', '2023-01-05', 'Electronics', 'non livré', '456 rue Bordeaux, Bordeaux', 'eBay', 'Doris', '456 rue Paris, Paris', '44.8378,-0.5792', 'FAC004'),
('COL005', '50', '60', '2023-01-05', '2023-01-06', 'Livres', 'livré', '567 rue Nantes, Nantes', 'Alibaba', 'Edgar', '567 rue Lyon, Lyon', '47.2186,-1.5536', 'FAC005'),
('COL006', '60', '70', '2023-01-06', '2023-01-07', 'Electronics', 'non livré', '678 rue Strasbourg, Strasbourg', 'Cdiscount', 'Fedor', '678 rue Paris, Paris', '48.5734,7.7521', 'FAC006'),
('COL007', '70', '80', '2023-01-07', '2023-01-08', 'Livres', 'livré', '789 rue Paris, Paris', 'Amazon', 'George', '789 rue Lyon, Lyon', '48.8566,2.3522', 'FAC007'),
('COL008', '80', '90', '2023-01-08', '2023-01-09', 'Electronics', 'non livré', '890 rue Lyon, Lyon', 'LDLC', 'Harry', '890 rue Paris, Paris', '45.75,4.85', 'FAC008'),
('COL009', '90', '100', '2023-01-09', '2023-01-10', 'Livres', 'livré', '901 rue Marseille, Marseille', 'Rakuten', 'Igor', '901 rue Lyon, Lyon', '43.2965,5.3698', 'FAC009'),
('COL010', '100', '110', '2023-01-10', '2023-01-11', 'Electronics', 'non livré', '012 rue Bordeaux, Bordeaux', 'eBay', 'James', '012 rue Paris, Paris', '44.8378,-0.5792', 'FAC010');

-- Remplir la table Contrat

INSERT INTO Contrat VALUES
('CNT001', '2023-01-01', '2024-01-01', 0.1, 0.1, 0.1, 'FAC001', 'CLI001'),
('CNT002', '2023-01-02', '2024-01-02', 0.2, 0.2, 0.2, 'FAC002', 'CLI002'),
('CNT003', '2023-01-03', '2024-01-03', 0.3, 0.3, 0.3, 'FAC003', 'CLI003'),
('CNT004', '2023-01-04', '2024-01-04', 0.4, 0.4, 0.4, 'FAC004', 'CLI004'),
('CNT005', '2023-01-05', '2024-01-05', 0.5, 0.5, 0.5, 'FAC005', 'CLI005'),
('CNT006', '2023-01-06', '2024-01-06', 0.6, 0.6, 0.6, 'FAC006', 'CLI006'),
('CNT007', '2023-01-07', '2024-01-07', 0.7, 0.7, 0.7, 'FAC007', 'CLI007'),
('CNT008', '2023-01-08', '2024-01-08', 0.8, 0.8, 0.8, 'FAC008', 'CLI008'),
('CNT009', '2023-01-09', '2024-01-09', 0.9, 0.9, 0.9, 'FAC009', 'CLI009'),
('CNT010', '2023-01-10', '2024-01-10', 1.0, 1.0, 1.0, 'FAC010', 'CLI010');

-- Remplir la table Livreur

INSERT INTO Livreur VALUES
('LIV001', 'John', '75', 'COL001'),
('LIV002', 'Jane', '69', 'COL002'),
('LIV003', 'Joe', '13', 'COL003'),
('LIV004', 'Jill', '33', 'COL004'),
('LIV005', 'Jack', '44', 'COL005'),
('LIV006', 'Julia', '35', 'COL006'),
('LIV007', 'Jim', '67', 'COL007'),
('LIV008', 'Jenny', '31', 'COL008'),
('LIV009', 'Jerry', '74', 'COL009'),
('LIV010', 'Jess', '83', 'COL010');

-- Remplir la table Envoie

INSERT INTO Envoie VALUES
('CLI001', 'COL001'),
('CLI002', 'COL002'),
('CLI003', 'COL003'),
('CLI004', 'COL004'),
('CLI005', 'COL005'),
('CLI006', 'COL006'),
('CLI007', 'COL007'),
('CLI008', 'COL008'),
('CLI009', 'COL009'),
('CLI010', 'COL010');

-- Remplir la table Stocke

INSERT INTO Stocke VALUES
('PR001', 'COL001'),
('PR002', 'COL002'),
('PR003', 'COL003'),
('PR004', 'COL004'),
('PR005', 'COL005'),
('PR006', 'COL006'),
('PR007', 'COL007'),
('PR008', 'COL008'),
('PR009', 'COL009'),
('PR010', 'COL010');