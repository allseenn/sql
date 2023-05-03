use lesson_4;
DROP PROCEDURE IF EXISTS lesson_4.sp_while;
DELIMITER $$
CREATE PROCEDURE lesson_4.sp_while(city varchar(100), out res INT)
BEGIN
declare cnt int;
declare step int;
set cnt = 0;
set step = (select max(user_id) from profiles);
while (step > 0) do
	begin
		IF (city = (select hometown from profiles where user_id = step)) THEN 
			set cnt = cnt + 1;
		end if;
	SET step = step - 1;
	end;
	end while;
	SET res = cnt;
END$$
DELIMITER ;

call sp_while("dd", @res);
select @res;
