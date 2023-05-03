use lesson_4;
DROP TRIGGER IF EXISTS tr_age_insert
DELIMITER $$
CREATE TRIGGER tr_age_before
BEFORE INSERT
ON profiles FOR EACH ROW
begin 
	if new.birthday > CURRENT_DATE() THEN 
		set new.birthday = CURRENT_DATE();
	end if;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS tr_age_update
DELIMITER //
CREATE trigger tr_age_update
BEFORE UPDATE 
ON profiles FOR EACH ROW 
BEGIN 
	if new.birthday > NOW() THEN 
		signal sqlstate '45000' 
		SET MESSAGE_TEXT = 'UPDATE CANCELED. Birthday could not be after today';
	end if;
END //
DELIMITER ;



