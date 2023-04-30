USE lesson_4;

/* Задача 1. 
Создайте представление, в которое попадет информация о пользователях 
(имя, фамилия, город и пол), которые не старше 20 лет.
*/
-- Решение 1
CREATE OR REPLACE VIEW teenagers AS
SELECT firstname, lastname, hometown, gender 
FROM profiles
JOIN users ON profiles.user_id = users.id
WHERE birthday > DATE_SUB(NOW(), INTERVAL 20 YEAR);
-- Решение 2
CREATE OR REPLACE VIEW teenagers AS
SELECT firstname, lastname, hometown, gender
FROM users
JOIN profiles ON users.id = profiles.user_id
WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, CURDATE()) <= 20;

-- SELECT * FROM teenagers;

/* Задача 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
 указав указать имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
 (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
*/
-- Решение 1
SELECT firstname, lastname, COUNT(*) Messages, 
DENSE_RANK() over(order by Messages DESC) Place 
FROM users 
JOIN messages ON users.id = messages.from_user_id  
WHERE body IS NOT NULL
GROUP BY users.id
ORDER BY Messages DESC;
-- Решение 2
SELECT firstname, lastname, COUNT(messages.id) AS Messages,
DENSE_RANK() OVER (ORDER BY COUNT(messages.id) DESC) AS Place
FROM users
JOIN messages ON users.id = messages.from_user_id
GROUP BY users.id
ORDER BY Place;

/* 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at)  
 и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
*/
-- Решение 1 - разница в секундах
SELECT body, created_at,
TIMESTAMPDIFF(SECOND, LAG(created_at) 
OVER (ORDER BY created_at), created_at) AS Seconds
FROM messages
ORDER BY created_at ASC;
-- Решение 2 (разница дат, т.е. дней)
SELECT body, created_at,
DATEDIFF((LAG(created_at) 
OVER(ORDER BY created_at)), created_at) AS Days
from messages
ORDER BY created_at;