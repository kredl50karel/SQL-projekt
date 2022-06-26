CREATE OR REPLACE TABLE t_Karel_Kredl_project_SQL_primary_final AS
WITH cena_tabulka AS  (
	SELECT 		 	 
		cpc.price_value, 
        cpc.code,		
		cpc.price_unit, 
        cpc.name AS potravina,		
		AVG(cp.value) AS average_food_price, 
		YEAR(cp.date_from) AS rok
	FROM czechia_price cp
	JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	WHERE cp.region_code IS NULL 		
	GROUP BY 
		potravina, cpc.price_value, cpc.code, cpc.price_unit, rok	
	), 	
plat_tabulka AS (
	SELECT 
		AVG(cpay.value) AS prumerna_vyplata, 
		cpib.code AS industry_branch_code, 
		cpib.name AS industry_branch_name, 
		cpay.payroll_year
	FROM czechia_payroll cpay
	JOIN czechia_payroll_industry_branch cpib
		ON cpay.industry_branch_code = cpib.code 
	WHERE 
		cpay.value_type_code = 5958 AND cpay.calculation_code = 100 
	GROUP BY 
		industry_branch_name, cpay.payroll_year, cpib.code
	) 
SELECT 
	cc.rok,  
	cc.code AS potravinovy_kod, 
	cc.potravina, 
	cc.average_food_price AS prumerna_cena, 
	cc.price_value AS mnozstvi, 
	cc.price_unit AS jednotka, 
	pt.prumerna_vyplata,
	pt.industry_branch_name AS odvetvi,
	pt.industry_branch_code 
FROM cena_tabulka cc
JOIN plat_tabulka pt
	ON cc.rok = pt.payroll_year
JOIN economies e 
	ON rok = e.`year` 
	AND e.country = 'Czech republic'
ORDER BY cc.rok;


SELECT * FROM t_Karel_Kredl_project_SQL_primary_final;

