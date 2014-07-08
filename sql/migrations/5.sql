DROP PROCEDURE IF EXISTS `get_rands`;
DELIMITER ;;

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rands`(IN cnt INT, IN sex CHAR, IN popular_flag BOOLEAN)
BEGIN

  DECLARE contender_id INT;
  DECLARE contender_sex VARCHAR(1);    

  DROP TEMPORARY TABLE IF EXISTS rands;
  CREATE TEMPORARY TABLE rands ( rand_id INT );


loop_me: LOOP
    IF cnt < 1 THEN
      LEAVE loop_me;
    END IF;
    
   SELECT @contender_id := r1.id, @contender_sex := r1.sex, @contender_recent_total_names := r1.recent_total_names
     FROM name AS r1 JOIN
          (SELECT (RAND() *
                        (SELECT MAX(id)
                           FROM name)) AS id)
           AS r2
    WHERE r1.id >= r2.id
    ORDER BY r1.id ASC
    LIMIT 1;
        
    IF (sex IS NULL OR @contender_sex = sex) AND ( (popular_flag = true AND @contender_recent_total_names > 5000) OR (popular_flag = false) ) THEN
      INSERT INTO rands (rand_id) values (@contender_id);
      SET cnt = cnt - 1;
    END IF;
    
  END LOOP loop_me;
END;;
DELIMITER ;