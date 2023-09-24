create table audit
(
    id         INT,
    table_name TEXT,
    date       TIMESTAMP
);

create or replace function audit_function() returns trigger
    language plpgsql
AS
$$
BEGIN
insert into audit (id,table_name,date)
    values (new.id, tg_table_name, now());
--     return new;
--     return old;
    return null;
end;
$$;

create trigger audit_aircraft_trigger
    AFTER UPDATE or INSERT or DELETE
    on aircraft
    for each row
    execute function audit_function();

insert into aircraft(model)
values ('new boing');