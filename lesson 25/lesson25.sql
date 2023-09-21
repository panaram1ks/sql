CREATE DATABASE company_repository;

CREATE SCHEMA company_storage;

DROP SCHEMA company_storage;

CREATE TABLE company_storage.company
(
    id   INT,
    name VARCHAR(128) UNIQUE NOT NULL,
    date DATE                NOT NULL CHECK (date > '1995-01-01' AND date < '2020-01-01'),
    PRIMARY KEY (id),
    UNIQUE (name)
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
       (3, 'Facebook', '1995-09-13'),
       (4, 'Amazon', '2005-06-17');

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
WHERE id = 10
   OR id = 9
    RETURNING id, first_name || ' ' || last_name fio;

CREATE DATABASE book_repository;

CREATE table company
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL
);

CREATE TABLE employee
(
    id         BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(128),
    last_name  VARCHAR(128),
    company_id INT REFERENCES company (id)
);

CREATE TABLE contact
(
    id     BIGSERIAL PRIMARY KEY,
    number VARCHAR(128) NOT NULL,
    type   VARCHAR(128)
);

create table employee_details
(
    id   BIGINT PRIMARY KEY REFERENCES employee (id),
    info TEXT
);

create table employee_contact
(
    employee_id BIGINT REFERENCES employee (id),
    contact_id  BIGINT REFERENCES contact (id),
    PRIMARY KEY (employee_id, contact_id)
);

drop table employee_contact;

drop table employee;

drop table contact cascade;

insert into contact (number, type)
values ('234-56-78', 'домашний'),
       ('987-65-43', 'рабочий'),
       ('565-25-91', 'мобильный'),
       ('332-55-67', NULL),
       ('465-11-22', NULL);

insert into employee (first_name, last_name)
values ('Ivan', 'Ivanov'),
       ('Sveta', 'Svetikova'),
       ('Petr', 'Petrov');

insert into employee_contact (employee_id, contact_id)
values (1, 1),
       (1, 2),
       (2, 2),
       (2, 3),
       (3, 4),
       (4, 5);


SELECT company.name,
       employee.first_name || employee.last_name fio
FROM employee,
     company
WHERE employee.company_id = company.id;

SELECT c.name,
       employee.first_name || ' ' || employee.last_name fio,
       ec.contact_id,
       c2.number
FROM employee
         JOIN company c
              ON employee.company_id = c.id
         JOIN employee_contact ec
              ON employee.id = ec.employee_id
         JOIN contact c2
              ON ec.contact_id = c2.id;

SELECT *
FROM company
         CROSS JOIN (select count(*) FROM employee) t;

-- JOIN
-- CROSS JOIN
-- LEFT JOIN
-- RIGHT JOIN
-- FULL JOIN

SELECT c.name,
       e.first_name
FROM company c
         LEFT JOIN employee e
                   ON c.id = e.company_id;

SELECT c.name,
       e.first_name
FROM employee e
         LEFT JOIN company c
                   on e.company_id = c.id;

SELECT c.name,
       e.first_name
FROM employee e
         RIGHT JOIN company c
                    ON e.company_id = c.id;


SELECT c.name,
       e.first_name
FROM employee e
         CROSS JOIN company c;

select company.name,
       e.first_name
--        count(e.id)
from company
         join employee e
              ON company.id = e.company_id
--      AND company.name = 'Apple'
where company.name = 'Apple';
-- GROUP BY company.id
-- HAVING count(e.id) > 0;

CREATE VIEW employee_view AS
select company.name,
       e.last_name,
       e.salary,
--        count(e.id) OVER (),
       max(e.salary) OVER (PARTITION BY company.name),
       min(e.salary) OVER (PARTITION BY company.name),
       lag(e.salary) OVER (ORDER BY e.salary) - e.salary
--        avg(e.salary) OVER (),
--        row_number() over (partition by company.name),
--        dense_rank() OVER (partition by company.name ORDER BY e.salary nulls first )
from company
         left join employee e
                   on company.id = e.company_id
order by company.name;

select *
from employee_view
where name = 'Facebook';

CREATE MATERIALIZED VIEW m_employee_view AS
select company.name,
       e.last_name,
       e.salary,
--        count(e.id) OVER (),
       max(e.salary) OVER (PARTITION BY company.name),
       min(e.salary) OVER (PARTITION BY company.name),
       lag(e.salary) OVER (ORDER BY e.salary) - e.salary
--        avg(e.salary) OVER (),
--        row_number() over (partition by company.name),
--        dense_rank() OVER (partition by company.name ORDER BY e.salary nulls first )
from company
         left join employee e
                   on company.id = e.company_id
order by company.name;

select *
from m_employee_view;

select *
from employee_view;

REFRESH MATERIALIZED VIEW m_employee_view;



ALTER TABLE IF EXISTS employee
    ADD COLUMN gender INT;

ALTER TABLE employee
    ALTER COLUMN gender SET NOT NULL ;

ALTER TABLE employee
    DROP COLUMN gender;

update employee
set gender = 1
where id <= 5;























