use lesson_4;
DROP PROCEDURE IF EXISTS sp_top5;
DELIMITER //
CREATE PROCEDURE sp_top5(sid INT)
BEGIN
DECLARE town VARCHAR(100);
SET town = (select hometown from profiles WHERE user_id=sid);

CREATE OR REPLACE VIEW v_friends AS  
(SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved'
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved');
	
select *  from users WHERE users.id IN (select user_id from profiles where hometown = town  and user_id != sid)
UNION 
select * from users WHERE id IN (
select DISTINCT community_id from users_communities 
join users ON users_communities.user_id = users.id
where users.id != sid )
UNION
select * from users WHERE id in (
SELECT fr.initiator_user_id AS friend_id
FROM v_friends f
JOIN lesson_4.friend_requests fr ON fr.target_user_id = f.friend_id
WHERE fr.initiator_user_id != sid AND f.user_id=sid  AND fr.status = 'approved'
UNION
SELECT fr.target_user_id 
FROM  v_friends f
JOIN  lesson_4.friend_requests fr ON fr.initiator_user_id = f.friend_id 
WHERE fr.target_user_id != sid  AND f.user_id=sid AND  status = 'approved'
) and users.id != sid
ORDER BY RAND()
LIMIT 5;

END //
DELIMITER ;

CALL sp_top5(1);