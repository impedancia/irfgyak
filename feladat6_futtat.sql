select sum(egyenleg) from bankszamla;

select * from bankszamla;
set serveroutput on
begin
    for i in 1..99 loop
       jutalom(1);
    end loop;
end;    