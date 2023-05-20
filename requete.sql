-- 1. Écrire une requête (listClientActifs) qui permet de donner la liste des clients actifs (contrat en cours de validité) avec les derniers coefficients.

SELECT c.ID_Client, c.RaisonSociale, c.NumRegistre, c.Telephone, cont.CoefPoids, cont.CoefTaille, cont.CoefPointRelais
FROM Client c
JOIN Contrat cont ON c.ID_Client = cont.ID_Client
WHERE cont.DateDebut <= CURDATE() AND cont.DateFin >= CURDATE();

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


-- 6. Écrire une requête (livraisonsEnCours) qui affiche la liste des colis en cours de livraison par livreur.

SELECT l.ID_Livreur, l.Nom, c.ID_Colis, c.DateLivraison, c.Contenu
FROM Livreur l
JOIN SuiviColis sc ON l.ID_Livreur = sc.ID_Livreur
JOIN Colis c ON sc.ID_Colis = c.ID_Colis
WHERE sc.EtatDeLivraison = 'En cours';

-- 7. Écrire une requête (attenteClient) qui affiche le nombre de colis en attente de livraison par client. Un colis est dit en attente de livraison s’il est prêt chez le client, mais pas encore retiré par le livreur (prendre aussi les cas où le client dépose lui-même les colis au point relais).

--> Je dois modifier un petit truc dans la base de données !

--> 8. Écrire une requête (avgColisTransit) qui donne le temps de transit moyen d’un colis par client.

--> Je dois modifier un petit truc dans la base de données !

--> Fait pour le point relais en dessous pour verifier si ca marche
SELECT c.ID_PointRelais_Reception, pr.RaisonSociale AS PointRelaisReception, AVG(TIMESTAMPDIFF(MINUTE, c.DatePriseEnCharge, c.DateLivraison))/60 AS TempsTransitMoyenEnHeures
FROM Colis c
JOIN PointRelais pr ON c.ID_PointRelais_Reception = pr.ID_PointRelais
WHERE c.DatePriseEnCharge IS NOT NULL AND c.DateLivraison IS NOT NULL
GROUP BY c.ID_PointRelais_Reception, PointRelaisReception;