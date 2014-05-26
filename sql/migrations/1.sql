ALTER TABLE `name` ADD COLUMN `total_names` int(11) DEFAULT NULL;

UPDATE name AS n 
JOIN (
	SELECT score.name_id, SUM(score.score) AS sum_names
    FROM `score` 
    GROUP BY score.name_id
) AS grp
ON grp.name_id = n.id
SET n.total_names = grp.sum_names;