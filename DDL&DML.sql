CREATE DATABASE company_repository;
CREATE SCHEMA company_storage;

DROP SCHEMA company_storage;
DROP DATABASE company_repository;

CREATE TABLE company (
    id INT,
    name varchar(128),
    date DATE
);