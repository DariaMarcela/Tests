WITH clear_map AS
	(SELECT DISTINCT dimension_1, correct_dimension_2
	FROM map),
cor_A_agg AS
	(SELECT a.dimension_1, m.correct_dimension_2 as dimension_2_new, sum(a.measure_1) as measure_1
	FROM tableA a
	LEFT JOIN clear_map m
	ON a.dimension_1= m.dimension_1
    GROUP BY a.dimension_1, dimension_2_new),
cor_B_agg AS
	(SELECT b.dimension_1, m.correct_dimension_2 as dimension_2_new, sum(b.measure_2) as measure_2
	FROM tableB b
	LEFT JOIN clear_map m
	ON b.dimension_1= m.dimension_1
    GROUP BY b.dimension_1, dimension_2_new) 
SELECT a.dimension_1, a.dimension_2_new as dimension_2, coalesce(a.measure_1, 0) as measure_1, coalesce(b.measure_2, 0) as measure_2
FROM cor_A_agg a 
LEFT JOIN cor_B_agg b
ON a.dimension_1 = b.dimension_1 AND a.dimension_2_new = b.dimension_2_new
UNION 
SELECT b.dimension_1, b.dimension_2_new as dimension_2, coalesce(a.measure_1, 0) as measure_1, coalesce(b.measure_2, 0) as measure_2
FROM cor_B_agg b 
LEFT JOIN cor_A_agg a
ON a.dimension_1 = b.dimension_1 AND a.dimension_2_new = b.dimension_2_new