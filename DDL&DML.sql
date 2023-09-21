CREATE DATABASE company_repository;
CREATE SCHEMA company_storage;

-- DROP SCHEMA company_storage;
-- DROP DATABASE company_repository;

DROP TABLE company_storage.company;

CREATE TABLE company_storage.company
(
    id   INT,          -- PRIMARY KEY
    name varchar(128), -- UNIQUE
    date DATE NOT NULL CHECK ( date > '1995-01-01' AND date < '2025-01-01'),
    PRIMARY KEY (id),
    UNIQUE (name, date)
-- UNIQUE
-- not null
-- CHECK (  )
-- primary key
-- FOREIGN KEY
);
-- DROP TABLE public.company;

INSERT INTO company_storage.company(id, name, date)
VALUES (1, 'Google', '2001-01-01'),
       (2, 'Apple', '2002-01-29'),
       (3, 'Facebook', '1998-09-13');

CREATE TABLE company_storage.employee
(
    id         SERIAL PRIMARY KEY,
    first_name varchar(128) not null,
    last_name  varchar(128) not null,
    company_id INT REFERENCES company_storage.company (id) ON DELETE CASCADE ,
    salary     INT,
    UNIQUE (first_name, last_name)
--     FOREIGN KEY (company_id) REFERENCES  company(id) -- second var write the same
);

DROP TABLE company_storage.employee;

insert into company_storage.employee (first_name, last_name, salary, company_id)
values ('Ivan', 'Sidorov', 500, 1),
       ('Ivan', 'Ivanov', 100, 2),
       ('Petr', 'Petrov', 2000, 2),
       ('Arny', 'Paramonov', NULL, 3),
       ('Sveta', 'Svetikova', 1500, NULL);

SELECT DISTINCT id,
                first_name AS f_name,
                last_name     l_name,
                salary
FROM company_storage.employee AS empl
-- WHERE salary > 1000    -- != or <>
-- WHERE first_name <> 'Ivan'
-- WHERE first_name LIKE 'Pet%'
-- WHERE first_name ILIKE 'pet%'
-- WHERE salary BETWEEN 1000 AND 1500
WHERE salary IN (500, 2000)
   OR first_name LIKE 'Sve%'
ORDER BY first_name, salary;
-- LIMIT 2
-- OFFSET 3;


-- sum, avg, max, min, count
SELECT upper(first_name),
       lower(last_name),
       concat(first_name, ' ', last_name) fio,
       first_name || ' ' || last_name     fioSecondVar,
       now()
FROM company_storage.employee;

SELECT sum(salary)
FROM company_storage.employee AS empl;

SELECT avg(salary)
FROM company_storage.employee AS empl;

-- count(*) - count all rows include NUL
-- count(salary) - count only rows where salary != NULL
SELECT count(*) -- count amount of rows in select
FROM company_storage.employee AS empl;


-- amount of columns should match and type of columns should match to each other
SELECT first_name
FROM company_storage.employee
WHERE company_id IS NOT NULL
-- UNION ALL
UNION
-- like distinct
SELECT first_name
FROM company_storage.employee
WHERE salary IS NULL;


-- we want get average salary both worst workers
-- alias for second dataset is required
SELECT avg(empl.salary)
FROM (SELECT *
      FROM company_storage.employee
      ORDER BY salary ASC
      LIMIT 2) AS empl;

SELECT *,
       (SELECT avg(salary) FROM company_storage.employee) avg,
       (SELECT max(salary) FROM company_storage.employee) max,
       (SELECT max(salary) FROM company_storage.employee) - salary diff
FROM company_storage.employee;

SELECT *
FROM company_storage.employee
WHERE company_id IN (SELECT id FROM company_storage.company WHERE date > '2001-01-01');

SELECT * FROM (values ('Ivan', 'Sidorov', 500, 1),
    ('Ivan', 'Ivanov', 100, 2),
    ('Petr', 'Petrov', 2000, 2),
    ('Arny', 'Paramonov', NULL, 3),
    ('Sveta', 'Svetikova', 1500, NULL)) al;


DELETE FROM company_storage.employee; -- delete all entries from table

DELETE FROM company_storage.employee
WHERE salary IS NULL ;

DELETE FROM company_storage.employee
WHERE salary = (SELECT max(salary) FROM company_storage.employee);

DELETE FROM company_storage.company
WHERE id = 1;

UPDATE company_storage.employee
SET company_id = 2,
    salary = 1800
WHERE id = 5
    RETURNING *;