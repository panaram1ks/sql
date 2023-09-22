# CREATE DATABASE company_repository;
# CREATE SCHEMA company_storage;
#
# -- DROP SCHEMA company_storage;
# -- DROP DATABASE company_repository;
#
# DROP TABLE company_storage.company;
#
# CREATE TABLE company_storage.company
# (
#     id   INT,          -- PRIMARY KEY
#     name varchar(128), -- UNIQUE
#     date DATE NOT NULL CHECK ( date > '1995-01-01' AND date < '2025-01-01'),
#     PRIMARY KEY (id),
#     UNIQUE (name, date)
# -- UNIQUE
# -- not null
# -- CHECK (  )
# -- primary key
# -- FOREIGN KEY
# );
# -- DROP TABLE public.company;
#
# INSERT INTO company_storage.company(id, name, date)
# VALUES (1, 'Google', '2001-01-01'),
#        (2, 'Apple', '2002-01-29'),
#        (3, 'Facebook', '1998-09-13');
#
# CREATE TABLE company_storage.employee
# (
#     id         SERIAL PRIMARY KEY,
#     first_name varchar(128) not null,
#     last_name  varchar(128) not null,
#     company_id INT REFERENCES company_storage.company (id) ON DELETE CASCADE,
#     salary     INT,
#     UNIQUE (first_name, last_name)
# --     FOREIGN KEY (company_id) REFERENCES  company(id) -- second var write the same
# );
#
# DROP TABLE company_storage.employee;
#
# insert into company_storage.employee (first_name, last_name, salary, company_id)
# values ('Ivan', 'Sidorov', 500, 1),
#        ('Ivan', 'Ivanov', 100, 2),
#        ('Petr', 'Petrov', 2000, 2),
#        ('Arny', 'Paramonov', NULL, 3),
#        ('Sveta', 'Svetikova', 1500, NULL);
#
# SELECT DISTINCT id,
#                 first_name AS f_name,
#                 last_name     l_name,
#                 salary
# FROM company_storage.employee AS empl
# -- WHERE salary > 1000    -- != or <>
# -- WHERE first_name <> 'Ivan'
# -- WHERE first_name LIKE 'Pet%'
# -- WHERE first_name ILIKE 'pet%'
# -- WHERE salary BETWEEN 1000 AND 1500
# WHERE salary IN (500, 2000)
#    OR first_name LIKE 'Sve%'
# ORDER BY first_name, salary;
# -- LIMIT 2
# -- OFFSET 3;
#
#
# -- sum, avg, max, min, count
# SELECT upper(first_name),
#        lower(last_name),
#        concat(first_name, ' ', last_name) fio,
#        first_name || ' ' || last_name     fioSecondVar,
#        now()
# FROM company_storage.employee;
#
# SELECT sum(salary)
# FROM company_storage.employee AS empl;
#
# SELECT avg(salary)
# FROM company_storage.employee AS empl;
#
# -- count(*) - count all rows include NUL
# -- count(salary) - count only rows where salary != NULL
# SELECT count(*) -- count amount of rows in select
# FROM company_storage.employee AS empl;
#
#
# -- amount of columns should match and type of columns should match to each other
# SELECT first_name
# FROM company_storage.employee
# WHERE company_id IS NOT NULL
# -- UNION ALL
# UNION
# -- like distinct
# SELECT first_name
# FROM company_storage.employee
# WHERE salary IS NULL;
#
#
# -- we want get average salary both worst workers
# -- alias for second dataset is required
# SELECT avg(empl.salary)
# FROM (SELECT *
#       FROM company_storage.employee
#       ORDER BY salary ASC
#       LIMIT 2) AS empl;
#
# SELECT *,
#        (SELECT avg(salary) FROM company_storage.employee)          avg,
#        (SELECT max(salary) FROM company_storage.employee)          max,
#        (SELECT max(salary) FROM company_storage.employee) - salary diff
# FROM company_storage.employee;
#
# SELECT *
# FROM company_storage.employee
# WHERE company_id IN (SELECT id FROM company_storage.company WHERE date > '2001-01-01');
#
# SELECT *
# FROM (values ('Ivan', 'Sidorov', 500, 1),
#     ('Ivan', 'Ivanov', 100, 2),
#     ('Petr', 'Petrov', 2000, 2),
#     ('Arny', 'Paramonov', NULL, 3),
#     ('Sveta', 'Svetikova', 1500, NULL)) al;
#
#
# DELETE
# FROM company_storage.employee; -- delete all entries from table
#
# DELETE
# FROM company_storage.employee
# WHERE salary IS NULL;
#
# DELETE
# FROM company_storage.employee
# WHERE salary = (SELECT max(salary) FROM company_storage.employee);
#
# DELETE
# FROM company_storage.company
# WHERE id = 1;
#
# UPDATE company_storage.employee
# SET company_id = 2,
#     salary     = 1800
# WHERE id = 5
#     RETURNING *;
#
#
# -- practice
# CREATE DATABASE book_repository;
#
# CREATE SCHEMA book_schema;
#
# CREATE TABLE book_schema.author
# (
#     id         SERIAL PRIMARY KEY,
#     first_name VARCHAR(128) not null,
#     last_name  VARCHAR(128) not null
# );
#
# CREATE TABLE book_schema.book
# (
#     id        BIGSERIAL PRIMARY KEY,
#     name      VARCHAR(128) not null,
#     year      SMALLINT     NOT NULL,
#     pages     SMALLINT     NOT NULL,
#     author_id INT REFERENCES book_schema.author (id)
# );
#
# INSERT INTO book_schema.author (first_name, last_name)
# VALUES ('Кей', 'Хорстманн'),
#        ('Стивен', 'Кови'),
#        ('Тони', 'Роббинс'),
#        ('Наполеон', 'Хилл'),
#        ('Роберт', 'Кийосаки'),
#        ('Дейл', 'Карнеги');
# SELECT *
# FROM book_schema.author;
#
# INSERT INTO book_schema.book (name, year, pages, author_id)
# values ('Java. Библиотеку профессионала. Том 1', 2010, 1102,
#         (SELECT id FROM book_schema.author WHERE last_name = 'Хорстманн')),
#        ('Java. Библиотеку профессионала. Том 2', 2012, 954,
#         (SELECT id FROM book_schema.author WHERE last_name = 'Хорстманн')),
#        ('Java SE 8. Вводный курс', 2015, 203, (SELECT id FROM book_schema.author WHERE last_name = 'Хорстманн')),
#        ('7 навыков высокоэффективных людей', 1989, 396, (SELECT id FROM book_schema.author WHERE last_name = 'Кови')),
#        ('Разбуди в себе исполина', 1991, 576, (SELECT id FROM book_schema.author WHERE last_name = 'Роббинс')),
#        ('Думай и богатей', 1937, 336, (SELECT id FROM book_schema.author WHERE last_name = 'Хилл')),
#        ('Богатый папа, бедный папа', 1997, 352, (SELECT id FROM book_schema.author WHERE last_name = 'Кийосаки')),
#        ('Квадрант денежного потока', 1998, 368, (SELECT id FROM book_schema.author WHERE last_name = 'Кийосаки')),
#        ('Как перестать беспокоиться и начать жить', 1948, 368,
#         (SELECT id FROM book_schema.author WHERE last_name = 'Карнеги')),
#        ('Как завоевывать друзей и оказывать влияние на людей', 1936, 352,
#         (SELECT id FROM book_schema.author WHERE last_name = 'Карнеги'));
#
# SELECT name, year, a.first_name
# FROM book_schema.book
#          INNER JOIN book_schema.author a on a.id = book.author_id
# ORDER BY year ASC;
# SELECT b.name,
#        b.year,
#        (SELECT a.first_name FROM book_schema.author a WHERE a.id = b.author_id)
# FROM book_schema.book b
# ORDER BY b.year;
#
#
# SELECT name, year, a.first_name
# FROM book_schema.book
#          INNER JOIN book_schema.author a on a.id = book.author_id
# ORDER BY year DESC;
#
# SELECT count(book.id), a.first_name
# FROM book_schema.book
#          INNER JOIN book_schema.author a on a.id = book.author_id
# GROUP BY a.first_name;
#
# SELECT *
# FROM book_schema.book
# where pages > (SELECT avg(pages) FROM book_schema.book);
#
#
# SELECT sum(pages)
# FROM book_schema.book
# WHERE year >= (SELECT min(year) FROM book_schema.book)
# LIMIT 5;
#
# SELECT *
# FROM book_schema.book
# ORDER BY year
# LIMIT 5;
#
# SELECT sum(pages) FROM book_schema.book;
#
# SELECT sum(pages) FROM (SELECT *
#                         FROM book_schema.book
#                         ORDER BY year
#                         LIMIT 5) as books;
#
#
#
# SELECT *, (SELECT sum(pages) FROM book_schema.book WHERE year >= (SELECT min(year) FROM book_schema.book) LIMIT 5)
# FROM book_schema.book
# WHERE year >= (SELECT min(year) FROM book_schema.book)
# group by id, name, year, pages, author_id
# LIMIT 5;
#
# UPDATE book_schema.book
# SET pages = 5000
# WHERE year = (SELECT max(year) FROM book_schema.book);
#
# DELETE
# FROM book_schema.author
# where id = (SELECT author_id FROM book_schema.book where pages = (SELECT max(pages) FROM book_schema.book))
#     RETURNING first_name, last_name;
#
# DELETE FROM book_schema.book
# WHERE author_id = (SELECT author_id FROM book_schema.book where pages = (SELECT max(pages) FROM book_schema.book));
#



SELECT company.name,
       employee.fio
FROM employee, company
WHERE employee.company_id = company.id;

SELECT company.name,
       employee.fio
FROM employee
JOIN company c
    ON employee.company_id = c.id;

-- INNER JOIN
-- CROSS JOIN
-- LEFT OUTER JOIN
-- RIGHT OUTER JOIN
-- FULL OUTER JOIN

