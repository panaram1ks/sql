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
    passenger_no   varchar(32)                   NOT NULL,
    passenger_name varchar(128)                  NOT NULL,
    flight_id      BIGINT REFERENCES flight (id) NOT NULL,
    seat_no        VARCHAR(4)                    NOT NULL,
    cost           NUMERIC(8, 2)                 NOT NULL,
    UNIQUE (flight_id, seat_no)
);

insert into airport (code, country, city)
values ('MNK', 'Беларусь', 'Минск'),
       ('LDN', 'Англия', 'Лондон'),
       ('MSK', 'Россия', 'Москва'),
       ('BSL', 'Испания', 'Барселона');

insert into aircraft (model)
values ('Боинг 777-300'),
       ('Боинг 737-300'),
       ('Аэробус A320-200'),
       ('Суперджет-100');

insert into seat (aircraft_id, seat_no)
select id, s.column1
from aircraft
         cross join (values ('A1'), ('A2'), ('B1'), ('B2'), ('C1'), ('C2'), ('D1'), ('D2') order by 1) s;

insert into flight (flight_no, departure_date, departure_airport_code, arrival_date, arrival_airport_code, aircraft_id,
                    status)
values ('MN3002', '2020-06-14T14:30', 'MNK', '2020-06-14T18:07', 'LDN', 1, 'ARRIVED'),
       ('MN3002', '2020-06-16T09:15', 'LDN', '2020-06-16T13:00', 'MNK', 1, 'ARRIVED'),
       ('BC2801', '2020-07-28T23:25', 'MNK', '2020-07-29T02:43', 'LDN', 2, 'ARRIVED'),
       ('BC2801', '2020-08-01T11:00', 'LDN', '2020-08-01T14:15', 'MNK', 2, 'DEPARTED'),
       ('TR3103', '2020-05-03T13:10', 'MSK', '2020-05-03T18:38', 'BSL', 3, 'ARRIVED'),
       ('TR3103', '2020-05-10T07:15', 'BSL', '2020-05-10T012:44', 'MSK', 3, 'CANCELLED'),
       ('CV9827', '2020-09-09T18:00', 'MNK', '2020-09-09T19:15', 'MSK', 4, 'SCHEDULED'),
       ('CV9827', '2020-09-19T08:55', 'MSK', '2020-09-19T10:05', 'MNK', 4, 'SCHEDULED'),
       ('QS8712', '2020-12-18T03:35', 'MNK', '2020-12-18T06:46', 'LDN', 2, 'ARRIVED');

insert into ticket (passenger_no, passenger_name, flight_id, seat_no, cost)
values ('112233', 'Иван Иванов', 1, 'A1', 200),
       ('23234A', 'Петр Петров', 1, 'B1', 180),
       ('SS988D', 'Светлана Светикова', 1, 'B2', 175),
       ('QYASDE', 'Андрей Андреев', 1, 'C2', 175),
       ('POQ234', 'Иван Кожемякин', 1, 'D1', 160),
       ('898123', 'Олег Рубцов', 1, 'A2', 198),
       ('555321', 'Екатерина Петренко', 2, 'A1', 250),
       ('QO23OO', 'Иван Розмаринов', 2, 'B2', 225),
       ('9883IO', 'Иван Кожемякин', 2, 'C1', 217),
       ('123UI2', 'Андрей Буйнов', 2, 'C2', 227),
       ('SS988D', 'Светлана Светикова', 2, 'D2', 277),
       ('EE2344', 'Дмитрий Трусцов', 3, 'А1', 300),
       ('AS23PP', 'Максим Комсомольцев', 3, 'А2', 285),
       ('322349', 'Эдуард Щеглов', 3, 'B1', 99),
       ('DL123S', 'Игорь Беркутов', 3, 'B2', 199),
       ('MVM111', 'Алексей Щербин', 3, 'C1', 299),
       ('ZZZ111', 'Денис Колобков', 3, 'C2', 230),
       ('234444', 'Иван Старовойтов', 3, 'D1', 180),
       ('LLLL12', 'Людмила Старовойтова', 3, 'D2', 224),
       ('RT34TR', 'Степан Дор', 4, 'A1', 129),
       ('999666', 'Анастасия Шепелева', 4, 'A2', 152),
       ('234444', 'Иван Старовойтов', 4, 'B1', 140),
       ('LLLL12', 'Людмила Старовойтова', 4, 'B2', 140),
       ('LLLL12', 'Роман Дронов', 4, 'D2', 109),
       ('112233', 'Иван Иванов', 5, 'С2', 170),
       ('NMNBV2', 'Лариса Тельникова', 5, 'С1', 185),
       ('DSA586', 'Лариса Привольная', 5, 'A1', 204),
       ('DSA583', 'Артур Мирный', 5, 'B1', 189),
       ('DSA581', 'Евгений Кудрявцев', 6, 'A1', 204),
       ('EE2344', 'Дмитрий Трусцов', 6, 'A2', 214),
       ('AS23PP', 'Максим Комсомольцев', 6, 'B2', 176),
       ('112233', 'Иван Иванов', 6, 'B1', 135),
       ('309623', 'Татьяна Крот', 6, 'С1', 155),
       ('319623', 'Юрий Дувинков', 6, 'D1', 125),
       ('322349', 'Эдуард Щеглов', 7, 'A1', 69),
       ('DIOPSL', 'Евгений Безфамильная', 7, 'A2', 58),
       ('DIOPS1', 'Константин Швец', 7, 'D1', 65),
       ('DIOPS2', 'Юлия Швец', 7, 'D2', 65),
       ('1IOPS2', 'Ник Говриленко', 7, 'C2', 73),
       ('999666', 'Анастасия Шепелева', 7, 'B1', 66),
       ('23234A', 'Петр Петров', 7, 'C1', 80),
       ('QYASDE', 'Андрей Андреев', 8, 'A1', 100),
       ('1QAZD2', 'Лариса Потемнкина', 8, 'A2', 89),
       ('5QAZD2', 'Карл Хмелев', 8, 'B2', 79),
       ('2QAZD2', 'Жанна Хмелева', 8, 'С2', 77),
       ('BMXND1', 'Светлана Хмурая', 8, 'В2', 94),
       ('BMXND2', 'Кирилл Сарычев', 8, 'D1', 81),
       ('SS988D', 'Светлана Светикова', 9, 'A2', 222),
       ('SS978D', 'Андрей Желудь', 9, 'A1', 198),
       ('SS968D', 'Дмитрий Воснецов', 9, 'B1', 243),
       ('SS958D', 'Максим Гребцов', 9, 'С1', 251),
       ('112233', 'Иван Иванов', 9, 'С2', 135),
       ('NMNBV2', 'Лариса Тельникова', 9, 'B2', 217),
       ('23234A', 'Петр Петров', 9, 'D1', 189),
       ('123951', 'Полина Зверева', 9, 'D2', 234);

SELECT *
FROM ticket
         JOIN flight f on f.id = ticket.flight_id
WHERE seat_no = 'B1'
  and departure_airport_code = 'MNK'
  and arrival_airport_code = 'LDN'
  and departure_date::date = (now() - interval '2 days')::date;

select interval '2 days';
select now() - interval '2 days';
select (now() - interval '2 days')::date;
select (now() - interval '2 days')::time;
select '124'::int;
-- select (now() - interval '2 days') CAST date;

SELECT flight_id, count(*)
FROM ticket
         JOIN flight f
              on f.id = ticket.flight_id
WHERE flight_no = 'MN3002'
  and departure_date::date = '2020-06-14'
GROUP BY flight_id;

-- SELECT * FROM seat
-- WHERE aircraft_id = (SELECT flight_id
--                      FROM ticket
--                               JOIN flight f
--                                    on f.id = ticket.flight_id
--                      WHERE flight_no = 'MN3002'
--                        and departure_date::date = '2020-06-14'
--                      GROUP BY flight_id);

SELECT aircraft_id, count(*)
FROM seat
WHERE aircraft_id = 1
GROUP BY aircraft_id;

SELECT t2.count - t1.count
FROM (SELECT aircraft_id, count(*)
      FROM ticket
               JOIN flight f
                    on f.id = ticket.flight_id
      WHERE flight_no = 'MN3002'
        and departure_date::date = '2020-06-14'
      GROUP BY aircraft_id) t1
         JOIN (SELECT aircraft_id, count(*)
               FROM seat
               GROUP BY aircraft_id) t2
              ON t1.aircraft_id = t2.aircraft_id;

SELECT EXISTS(select 1 from ticket where id = 2);

-- second var
select s.seat_no
from seat s
where aircraft_id = 1
  and not exists (SELECT seat_no
                  FROM ticket t
                           JOIN flight f
                                on f.id = t.flight_id
                  WHERE flight_no = 'MN3002'
                    and departure_date::date = '2020-06-14'
                      and s.seat_no = t.seat_no);

select  f.id,
        f.arrival_date,
        f.departure_date,
        (f.arrival_date - f.departure_date) duration
from flight f
order by  (f.arrival_date - f.departure_date) DESC ;

select first_value(f.arrival_date - f.departure_date)
                   over (order by (f.arrival_date - f.departure_date) desc )  max_value,
       first_value(f.arrival_date - f.departure_date)
                   over (order by (f.arrival_date - f.departure_date) asc )   min_value,
       count(*) over ()
from flight f
         join airport a on f.arrival_airport_code = a.code
         join airport d on f.departure_airport_code = d.code
where a.city = 'Лондон'
  and d.city = 'Минск'
limit 1;

select t.passenger_name,
       count(*),
       100.0 * count(*) / (select count(*) from ticket),
       round(100.0 * count(*) / (select count(*) from ticket), 2)
from ticket t
group by t.passenger_name
-- order by count(*) desc ;
order by 2 desc;


select t1.*,
       first_value(t1.cnt) over () - t1.cnt AS difference
from (
         select t.passenger_name,
                t.passenger_no,
                count(*) AS cnt
         from ticket t
         group by t.passenger_name, t.passenger_no
         order by 3 desc) t1;

select t1.*,
       COALESCE(lead(sum_cost) over ( order by t1.sum_cost), 0),
       COALESCE(lead(sum_cost) over ( order by t1.sum_cost), 0) - t1.sum_cost
from (select t.flight_id, f.arrival_airport_code, f.departure_airport_code, sum(t.cost) as sum_cost
      from ticket t
               join flight f on f.id = t.flight_id
      group by t.flight_id, f.arrival_airport_code, f.departure_airport_code
      order by sum(t.cost) desc) t1