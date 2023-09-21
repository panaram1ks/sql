explain select *
        from ticket
        where passenger_name like 'Иван%'
          and seat_no = 'B1';

explain
select flight_id, count(*), sum(cost)
from ticket
group by flight_id;


-- синтаксический (rule-based)
-- стоимостной (cost-based)

-- page_cost (input-output) = 1.0
-- cpu_cost 0.01

-- 55 * 0.01 = 0.55 (cpu_cost)
-- 1 * 1.0 = 1.0 (page_cost)
--          1.55

-- 8 + 6 + 28 + 8 + 2 + 8 = 60

select avg(bit_length(passenger_no) / 8),
       avg(bit_length(passenger_name) / 8),
       avg(bit_length(seat_no) / 8)
from ticket;

select reltuples,
       relkind,
       relpages
from pg_class
where relname = 'ticket';


explain
select *
from ticket
where id = 25;

create table test1 (
                       id SERIAL PRIMARY KEY ,
                       number1 INT NOT NULL ,
                       number2 INT NOT NULL ,
                       value VARCHAR(32) NOT NULL
);

create index test1_number1_idx ON test1(number1);
create index test1_number2_idx ON test1(number2);

insert into test1 (number1, number2, value)
select random() * generate_series,
       random() * generate_series,
       generate_series
from generate_series(1, 100000);

select relname,
       reltuples,
       relkind,
       relpages
from pg_class
where relname like 'test1%';

analyze test1;

explain analyze
select *
from test1
where number1 < 10000;

-- index only scan
-- index scan
-- bitmap scan (index scan, heap scan)

-- 0 1 0 0 1 0 1 1 0 0 0 ... 636 times
-- 2 5 7 8

-- 0 1 0 0 1 0 1 1 0 0 0 ... 636 times
-- 0 0 0 1 1 0 0 1 0 0 0 ... 636 times

-- 0 1 0 1 1 0 1 1 0 0 0 ... 636 times OR
-- 0 0 0 0 1 0 0 1 0 0 0 ... 636 times AND

create table test2
(
    id SERIAL PRIMARY KEY ,
    test1_id INT REFERENCES test1 (id) NOT NULL ,
    number1 INT NOT NULL ,
    number2 INT NOT NULL ,
    value VARCHAR(32) NOT NULL
);

insert into test2 (test1_id, number1, number2, value)
select id,
       random() * number1,
       random() * number2,
       value
from test1;

create index test2_number1_idx on test2 (number1);
create index test2_number2_idx on test2 (number2);
create index test2_test1_id_idx on test2 (test1_id);

explain analyze
select *
from test1 t1
-- join (select * from test2 order by test1_id) t2
         join test2 t2
              on t1.id = t2.test1_id;

analyze test2;

-- nested loop 100
-- hash join
-- merge join

-- 8 9 10 22 ... test2.test1_id
-- 7 9 10 18 ... test1.id
