ALTER TABLE IF EXISTS company_storage.employee
    ADD COLUMN gender INT;

UPDATE company_storage.employee
SET gender = 1
WHERE id <= 5;

ALTER TABLE company_storage.employee
    ALTER COLUMN gender SET NOT NULL ;

ALTER TABLE company_storage.employee
    DROP COLUMN gender;




CREATE DATABASE flight_repository;

CREATE TABLE airport
(
    code    CHAR(3) PRIMARY KEY,
    country VARCHAR(256) NOT NULL,
    city    VARCHAR(128) NOT NULL
);

CREATE TABLE aircraft
(
    id    SERIAL PRIMARY KEY,
    model varchar(128) NOT NULL
);

CREATE TABLE seat
(
    aircraft_id INT REFERENCES aircraft (id),
    seat_no     VARCHAR(4) NOT NULL,
    PRIMARY KEY (aircraft_id, seat_no)
);

CREATE TABLE flight
(
    id                     BIGSERIAL PRIMARY KEY,
    flight_no              VARCHAR(16)                       NOT NULL,
    departure_date         TIMESTAMP                         NOT NULL,
    departure_airport_code char(3) REFERENCES airport (code) NOT NULL,
    arrival_date           TIMESTAMP                         NOT NULL,
    arrival_airport_code   CHAR(3) REFERENCES airport (code) NOT NULL,
    aircraft_id            INT REFERENCES aircraft (id)      NOT NULL,
    status                 varchar(32)                       NOT NULL
);

CREATE TABLE ticket
(
    id             BIGSERIAL PRIMARY KEY,
    passenger_no   varchar(32) NOT NULL ,
    passenger_name varchar(128) NOT NULL ,
    flight_id      BIGINT REFERENCES flight (id) NOT NULL ,
    seat_no        VARCHAR(4) NOT NULL,
    cost           NUMERIC(8, 2) NOT NULL ,
    UNIQUE (flight_id, seat_no)
);
