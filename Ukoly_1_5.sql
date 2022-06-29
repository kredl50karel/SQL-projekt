/* Otázka è.1 Rostou v prùbìhu let mzdy ve všech odvìtvích,
nebo v nìkterých klesají?  
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

/* Otázka è.2 Kolik je možné si koupit litrù mléka a kilogramù chleba za první 
 a poslední srovnatelné období v dostupných datech cen a mezd?
*/

  SELECT
		rok,
		potravina,
		ROUND(AVG(prumerna_cena), 2) AS prumerna_cena,
		ROUND(AVG(prumerna_vyplata), 2) AS prumerna_vyplata,
		ROUND(AVG(prumerna_vyplata) / AVG(prumerna_cena)) AS množství_za_mzdu
FROM t_Karel_Kredl_project_SQL_primary_final 	
WHERE 
		(potravina = 'Chléb konzumní kmínový'
		OR potravina = 'Mléko polotuèné pasterované')
		AND (rok = 2006 OR rok = 2018)
GROUP BY rok, potravina; 

/* Otázka è.3 Která kategorie potravin zdražuje nejpomaleji
 (je u ní nejnižší percentuální meziroèní nárùst)?
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

/* Otázka è.4 Existuje rok, ve kterém byl meziroèní nárùst cen potravin výraznì vyšší
   než rùst mezd (vìtší než 10 %)?
*/

WITH ta1 AS (
	SELECT 
		rok AS rok_1, 
		ROUND(AVG(prumerna_cena),2) AS prumerna_cena_1, 
		ROUND(AVG(prumerna_vyplata)) AS prumerna_vyplata_1
	FROM t_Karel_Kredl_project_SQL_primary_final  
	GROUP BY rok
), 
ta2 AS (
	SELECT 
		rok AS rok_2, 
		ROUND(AVG(prumerna_cena),2) AS prumerna_cena_2, 
		ROUND(AVG(prumerna_vyplata)) AS prumerna_vyplata_2
	FROM t_Karel_Kredl_project_SQL_primary_final  
	GROUP BY rok
) 
SELECT 
	*, 
	ROUND((ta2.prumerna_cena_2 - ta1.prumerna_cena_1) /
	ta1.prumerna_cena_1 * 100, 2) AS rozdil_potravina_procenta,
	ROUND((ta2.prumerna_vyplata_2  - prumerna_vyplata_1) /
	ta1.prumerna_vyplata_1 * 100, 2) AS rozdil_plat_procenta
FROM ta1
JOIN ta2
	ON ta1.rok_1 = ta2.rok_2 - 1;	

/* Otázka è.5 Má výška HDP vliv na zmìny ve mzdách a cenách potravin? 
  Neboli, pokud HDP vzroste výraznìji v jednom roce,
  projeví se to na cenách potravin èi mzdách ve stejném nebo
   následujícím roce výraznìjším rùstem?
*/
SELECT 
	dat1.*, 
	ROUND((HDP - predchozi_rok_HDP) / predchozi_rok_HDP * 100, 2) AS zmena_procenta
FROM
(SELECT 
	rok, 
	HDP,
	LAG(HDP,1) OVER ( 
		ORDER BY rok) AS predchozi_rok_HDP	 
FROM t_Karel_Kredl_project_SQL_secondary_final
WHERE zkratka = 'CZ' AND rok BETWEEN '2006' AND '2018'
ORDER BY rok) dat1 
ORDER BY zmena_procenta DESC;




















