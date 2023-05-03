use lesson_4;

DROP FUNCTION IF EXISTS lesson_4.fn_find;
DELIMITER $$
CREATE FUNCTION lesson_4.fn_find(friend INT)
RETURNS FLOAT READS SQL DATA
BEGIN
DECLARE target INT;
DECLARE initiator INT;
SET target = (select count(target_user_id)  from lesson_4.friend_requests 
WHERE target_user_id = friend);
SET initiator = (select count(initiator_user_id)  from lesson_4.friend_requests 
WHERE initiator_user_id = friend);
RETURN target / initiator;
END$$
DELIMITER ;

select TRUNCATE(fn_find(1),2);