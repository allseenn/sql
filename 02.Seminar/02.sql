-- переименование таблицы movies в cinema   
RENAME TABLE movies TO cinema;

-- добавление новых столбцов status_active и genre_id в таблицу cinema
ALTER TABLE cinema
ADD COLUMN status_active BIT DEFAULT b'1',
ADD genre_id BIGINT UNSIGNED AFTER title_eng;

-- удаление столбца status_active из таблицы cinema
ALTER TABLE cinema
DROP COLUMN status_active;

-- удаление таблицы actors
DROP TABLE actors;

-- добавление внешнего ключа от поля genre_id таблицы cinema к полю id таблицы genres
ALTER TABLE cinema
ADD FOREIGN KEY(genre_id) REFERENCES genres(id);
 
-- очистить таблицу от данных 
-- TRUNCATE TABLE genres;

ALTER TABLE cinema
DROP FOREIGN KEY cinema_ibfk_1;

TRUNCATE TABLE genres;

ALTER TABLE cinema
ADD FOREIGN KEY(genre_id) REFERENCES genres(id) 
ON UPDATE CASCADE ON DELETE SET NULL;