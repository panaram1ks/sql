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