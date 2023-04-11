DROP TABLE IF EXISTS workers;
CREATE TABLE workers (
    id INT  NOT NULL, 
    name_worker VARCHAR(45),
    dept VARCHAR(100) COMMENT 'Подразделение', -- COMMENT на случай, если имя неочевидное,
    salary INT,
    PRIMARY KEY(id)
);

INSERT INTO workers (id, name_worker, dept, salary)
VALUES 
(100, 'AndreyEx', 'Sales', 5000),
(200, 'Boris', 'IT', 5500),
(300, 'Anna', 'IT', 7000),
(400, 'Anton', 'Marketing', 9500),
(500, 'Dima', 'IT', 6000),
(501, 'Maxs', 'Accounting', NULL);