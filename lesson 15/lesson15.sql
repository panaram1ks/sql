CREATE DATABASE company_repository;

CREATE SCHEMA company_storage;

DROP SCHEMA company_storage;

CREATE TABLE company_storage.company
(
    id   INT,
    name VARCHAR(128) UNIQUE NOT NULL,
    date DATE                NOT NULL CHECK (date > '1995-01-01' AND date < '2020-01-01'),
    PRIMARY KEY (id),
    UNIQUE (name, date)
--     NOT NULL
-- UNIQUE
-- CHECK
-- PRIMARY KEY == UNIQUE NOT NULL
-- , FOREIGN KEY
);

DROP TABLE company_storage.company;

INSERT INTO company(id, name, date)
VALUES (1, 'Google', '2001-01-01'),
       (2, 'Apple', '2002-10-29'),
       (3, 'Facebook', '1995-09-13');

-- DROP TABLE public.company;

CREATE TABLE employee
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL,
    company_id INT REFERENCES company (id) ON DELETE CASCADE,
    salary     INT,
    UNIQUE (first_name, last_name)
--     FOREIGN KEY (company_id) REFERENCES company
);

DROP TABLE employee;

INSERT INTO employee(first_name, last_name, salary, company_id)
VALUES ('Ivan', 'Sidorov', 500, 1),
       ('Ivan', 'Ivanov', 1000, 2),
       ('Arni', 'Paramonov', NULL, 2),
       ('Petr', 'Petrov', 2000, 3),
       ('Sveta', 'Svetikova', 1500, NULL);
-- sum, avg, max, min, count
SELECT lower(first_name),
--        concat(first_name, ' ', last_name) fio
       first_name || ' ' || last_name fio,
       now()
FROM employee empl;
-- WHERE salary IN (1000, 1100, 2000)
--    OR (first_name LIKE 'Iv%'
--     AND last_name ILIKE '%ov%')
-- ORDER BY first_name, salary DESC;
-- > < >= <= = !=
-- BETWEEN
-- LIKE (ILIKE) %                AND - OR
-- IN
SELECT now(), 1 * 2 + 3;

SELECT id,
       first_name
FROM employee
WHERE company_id IS NOT NULL
UNION
SELECT id,
       first_name
FROM employee
WHERE salary IS NULL;

SELECT avg(empl.salary)
FROM (SELECT *
      FROM employee
      ORDER BY salary DESC
      LIMIT 2) empl;

select *,
       (select max(salary) from employee) - salary diff
from employee;

select *
from employee
where company_id IN (select company.id from company where date > '2000-01-01');

SELECT *
FROM employee
ORDER BY salary
LIMIT 2;

select *
from (select *
      from (VALUES (1, 'Google', '2001-01-01'),
          (2, 'Apple', '2002-10-29'),
          (3, 'Facebook', '1995-09-13')) t) y;

DELETE
FROM employee
WHERE salary IS NULL;

DELETE
FROM employee
WHERE salary = (SELECT max(salary) FROM employee);

DELETE
FROM company
WHERE id = 2;

DELETE
FROM employee
WHERE company_id = 1;

select *
from employee;

UPDATE employee
SET company_id = 1,
    salary     = 1700
WHERE id = 10 OR id = 9
    RETURNING id, first_name || ' ' || last_name fio;

CREATE DATABASE book_repository;
















