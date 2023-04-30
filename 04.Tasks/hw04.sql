USE lesson_4;

/* Задача 1.
Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
*/
SELECT count(media_id) AS 'All_likes_for_babies' from likes where media_id IN
(SELECT id from media where user_id IN 
(SELECT user_id FROM profiles WHERE birthday > DATE_SUB(NOW(), INTERVAL 12 YEAR)));

/* Задача 2. 
Определить кто больше поставил лайков (всего): мужчины или женщины.
*/
SELECT 
CASE
	WHEN gender='f' THEN 'женщины'
	WHEN gender='m' THEN 'мужчины'
END AS 'Sex',
COUNT(*) AS 'Likes'
FROM likes
JOIN profiles ON likes.user_id = profiles.user_id
GROUP BY gender
ORDER BY COUNT(*) DESC
LIMIT 1;

/*
3. Вывести всех пользователей, которые не отправляли сообщения.
*/
-- Решение 1
SELECT id, CONCAT(firstname, ' ', lastname) AS 'Users'  FROM users WHERE id NOT IN 
(SELECT from_user_id FROM messages);

-- Решение 2
SELECT users.id, CONCAT(firstname, ' ', lastname) AS 'Users' FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
WHERE messages.from_user_id is NULL;

/*
4. (по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.
*/
-- Решение 1, пусть users.id = 1
SELECT users.id, CONCAT(firstname, ' ', lastname) AS 'User', COUNT(users.id) AS 'Messages' FROM users
RIGHT JOIN messages ON users.id = messages.from_user_id  
WHERE messages.to_user_id = 1
GROUP BY users.id ORDER BY users.id desc LIMIT 1;

-- Решение 2 - поиск самого болтливого юзера без заданного айдишника
 SELECT id, CONCAT(firstname, ' ', lastname) AS 'Spamer' FROM users WHERE id = 
 (SELECT from_user_id FROM messages GROUP BY from_user_id, to_user_id ORDER BY COUNT(*) DESC LIMIT 1); 
