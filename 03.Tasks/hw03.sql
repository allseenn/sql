/* Задача 1
Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
*/
SELECT * FROM staff ORDER BY salary;
SELECT * FROM staff ORDER BY salary DESC;

/* Задача 2
Выведите 5 максимальных заработных плат (salary)
*/
SELECT salary FROM staff ORDER BY salary DESC LIMIT 5;

/* Задача 3
Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
*/
SELECT post, sum(salary) FROM staff GROUP BY post;

/* Задача 4
Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
*/
SELECT COUNT(*) FROM staff WHERE post="Рабочий" AND age BETWEEN 24 AND 49;

/* Задача 5
Найдите количество специальностей
*/
SELECT COUNT(DISTINCT post) FROM staff;

/* Задача 6. 
Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
*/
SELECT post FROM staff GROUP BY post HAVING AVG(age) < 30;