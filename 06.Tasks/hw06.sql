USE lesson_4;

/* Задача 1
Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно). */

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (id BIGINT UNSIGNED, firstname VARCHAR(50),
lastname VARCHAR(50) COMMENT 'Фамилия', email VARCHAR(120));

DROP PROCEDURE IF EXISTS sp_user_del;
DELIMITER //
CREATE PROCEDURE sp_user_del(userid INT, OUT  tran_result varchar(100))
BEGIN
	DECLARE rolling BIT DEFAULT b'0';
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 
	DECLARE nouser VARCHAR(100);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET rolling = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;
	SET nouser = (SELECT email from users WHERE id = userid);
	IF (nouser) IS NULL THEN
    	SET rolling = b'1';
    	SET code = '1048'; 
    	SET error_string = CONCAT('Пользователь c id ', userid, ' не найден');	
	END IF;
	START TRANSACTION;
		INSERT INTO users_old (id, firstname, lastname, email)
		SELECT * FROM users WHERE id = userid;
		DELETE FROM users WHERE id = userid;
	IF rolling THEN
		SET tran_result = CONCAT('Ошибка: ', code, ' ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = CONCAT('Пользователь с id ', userid, ' перемещен в архив');
		COMMIT;
	END IF;
END //
DELIMITER ;

-- CALL sp_user_del(7, @trans_result);
-- SELECT @trans_result;

/* Задача 2
Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 
c 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер",
с 00:00 до 6:00 — "Доброй ночи". */

DROP FUNCTION IF EXISTS hello;
DELIMITER $$
CREATE FUNCTION hello()
RETURNS VARCHAR(100) READS SQL DATA
BEGIN
	DECLARE greet VARCHAR(100);
	SET greet = (SELECT 
	CASE
		WHEN CURRENT_TIME BETWEEN '06:00:00' AND '11:59:59' THEN "Доброе утро!"
		WHEN CURRENT_TIME BETWEEN '12:00:00' AND '17:59:59' THEN "Добрый день!"
		WHEN CURRENT_TIME BETWEEN '18:00:00' AND '23:59:59' THEN "Добрый вечер!"
		WHEN CURRENT_TIME BETWEEN '00:00:00' AND '05:59:59' THEN "Доброй ночи!"
		ELSE "Настройте время!"
	END);
RETURN greet;
END$$
DELIMITER ;

-- select hello();

/* Задача 3
(по желанию)* Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, 
название таблицы, идентификатор первичного ключа. */
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (id SERIAL PRIMARY KEY, created DATETIME, name VARCHAR(100), pri_id BIGINT UNSIGNED);

DROP TRIGGER IF EXISTS tr_users;
DELIMITER $$
CREATE TRIGGER tr_users
AFTER INSERT
ON users FOR EACH ROW
BEGIN
	INSERT INTO logs (created, name, pri_id)
	VALUES (NOW(), 'users', NEW.id);
END $$
DELIMITER ;

-- insert into users (firstname, lastname, email) values ('Gary', 'Kildall', 'info@DigitalResearch.biz');
-- select users.id, users.firstname, users.lastname, users.email, logs.id, logs.created, logs.name, logs.pri_id from users JOIN logs ON users.id = logs.pri_id ORDER BY users.id DESC LIMIT 1;

DROP TRIGGER IF EXISTS tr_messages;
DELIMITER $$
CREATE TRIGGER tr_messages
AFTER INSERT
ON messages FOR EACH ROW
BEGIN
	INSERT INTO logs (created, name, pri_id)
	VALUES (NOW(), 'messages', NEW.id);
END $$
DELIMITER ;

-- insert into messages (from_user_id, to_user_id, body, created_at) values (5, 10, 'Hell, world!', now());
-- select messages.id, messages.from_user_id, messages.to_user_id, messages.body, messages.created_at, logs.id, logs.created, logs.name, logs.pri_id from messages JOIN logs ON messages.id = logs.pri_id ORDER BY messages.id DESC LIMIT 1;

DROP TRIGGER IF EXISTS tr_communities;
DELIMITER $$
CREATE TRIGGER tr_communities
AFTER INSERT
ON communities FOR EACH ROW
BEGIN
	INSERT INTO logs (created, name, pri_id)
	VALUES (NOW(), 'communities', NEW.id);
END $$
DELIMITER ;

-- insert into communities (name) values ('Pickup Club');
-- select communities.id, communities.name, logs.id, logs.created, logs.name, logs.pri_id from communities JOIN logs ON communities.id = logs.pri_id ORDER BY communities.id DESC LIMIT 1;