/* Ot�zka �.1 Rostou v pr�b�hu let mzdy ve v�ech odv�tv�ch,
nebo v n�kter�ch klesaj�?  
*/ 

WITH tab1 AS (
SELECT
	DISTINCT 
		rok, 
		prumerna_vyplata, 
		odvetvi,
		industry_branch_code
FROM
	t_Karel_Kredl_project_SQL_primary_final	
	), 
tab2 AS (
SELECT
	DISTINCT 
		rok, 
		prumerna_vyplata, 		
		odvetvi,
		industry_branch_code
FROM
	t_Karel_Kredl_project_SQL_primary_final	
	)
SELECT 
	tab1.rok AS rok1, 
	tab1.odvetvi,
	tab1.industry_branch_code,
	tab1.prumerna_vyplata, 
	tab2.rok AS rok2, 
	tab2.prumerna_vyplata, 
	ROUND((tab2.prumerna_vyplata - tab1.prumerna_vyplata) / tab1.prumerna_vyplata * 100,2) AS rozdil_procenta
FROM
	tab1
JOIN tab2
	ON
	tab1.industry_branch_code = tab2.industry_branch_code
	AND tab1.rok = tab2.rok - 1
ORDER BY
	rozdil_procenta;

/* Ot�zka �.2 Kolik je mo�n� si koupit litr� ml�ka a kilogram� chleba za prvn� 
 a posledn� srovnateln� obdob� v dostupn�ch datech cen a mezd?
*/

  SELECT
		rok,
		potravina,
		ROUND(AVG(prumerna_cena), 2) AS prumerna_cena,
		ROUND(AVG(prumerna_vyplata), 2) AS prumerna_vyplata,
		ROUND(AVG(prumerna_vyplata)/AVG(prumerna_cena)) AS food_amount_to_avg_salary
FROM t_Karel_Kredl_project_SQL_primary_final 	
WHERE 
		(potravina = 'Chl�b konzumn� km�nov�'
		OR potravina = 'Ml�ko polotu�n� pasterovan�')
		AND (rok = 2006 OR rok = 2018)
GROUP BY rok, potravina; 

/*Kter� kategorie potravin zdra�uje nejpomaleji
 (je u n� nejni��� percentu�ln� meziro�n� n�r�st)?
*/

WITH maxrok AS (
	SELECT DISTINCT potravina, rok, prumerna_cena FROM t_Karel_Kredl_project_SQL_primary_final
	WHERE rok = (SELECT MAX(rok) FROM t_Karel_Kredl_project_SQL_primary_final)
), 
	minrok AS (
	SELECT DISTINCT potravina, rok, prumerna_cena FROM t_Karel_Kredl_project_SQL_primary_final
	WHERE rok = (SELECT MIN(rok) FROM t_Karel_Kredl_project_SQL_primary_final)
) 
SELECT maxrok.*, minrok.rok, minrok.prumerna_cena, 
ROUND((maxrok.prumerna_cena - minrok.prumerna_cena) / minrok.prumerna_cena  * 100,2)
AS rozdil_procenta_roky FROM maxrok
JOIN minrok
ON maxrok.potravina = minrok.potravina
GROUP BY rozdil_procenta_roky;



























