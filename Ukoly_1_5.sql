/* Otázka è.1 Rostou v prùbìhu let mzdy ve všech odvìtvích,
nebo v nìkterých klesají?  
*/ 

WITH tab1 AS (
	SELECT DISTINCT 
		rok, 
		prumerna_vyplata, 
		odvetvi,
		industry_branch_code
     FROM t_Karel_Kredl_project_SQL_primary_final	
	), 
tab2 AS (
	SELECT DISTINCT 
		rok, 
		prumerna_vyplata, 		
		odvetvi,
		industry_branch_code
     FROM t_Karel_Kredl_project_SQL_primary_final	
	)
SELECT 
	tab1.rok AS rok1, 
	tab1.odvetvi,
    tab1.industry_branch_code,	
    tab1.prumerna_vyplata, 
	tab2.rok AS rok2, 
	tab2.prumerna_vyplata, 
	ROUND((tab2.prumerna_vyplata - tab1.prumerna_vyplata) / tab1.prumerna_vyplata * 100,2) AS rozdil_procenta
FROM tab1
JOIN tab2
	ON tab1.industry_branch_code = tab2.industry_branch_code
    AND tab1.rok = tab2.rok - 1
 ORDER BY rozdil_procenta;

/* Otázka è.2 Kolik je možné si koupit litrù mléka a kilogramù chleba za první 
 a poslední srovnatelné období v dostupných datech cen a mezd?
*/

  SELECT
		rok,
		potravina,
		ROUND(AVG(prumerna_cena), 2) AS prumerna_cena,
		ROUND(AVG(prumerna_vyplata), 2) AS prumerna_vyplata,
		ROUND(AVG(prumerna_vyplata)/AVG(prumerna_cena)) AS food_amount_to_avg_salary
FROM t_Karel_Kredl_project_SQL_primary_final 	
WHERE 
		(potravina = 'Chléb konzumní kmínový'
		OR potravina = 'Mléko polotuèné pasterované')
		AND (rok = 2006 OR rok = 2018)
GROUP BY rok, potravina; 
