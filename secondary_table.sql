CREATE OR REPLACE TABLE t_Karel_Kredl_project_SQL_secondary_final (
	SELECT
		c.country AS zemì, 
		c.abbreviation AS zkratka, 
		e.`year` AS rok, 
		e.population,
		e.GDP AS HDP, 
		e.gini AS ekonomicka_nerovnost
	FROM countries c
	LEFT JOIN economies e ON c.country = e.country
	WHERE e.`year` BETWEEN '2006' AND '2018'
	);
	
SELECT * FROM t_Karel_Kredl_project_SQL_secondary_final;

