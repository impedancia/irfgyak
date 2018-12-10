declare
    dolg dolgozo%rowtype;
    dolg2 dolgozo%rowtype;
    dp dept%rowtype;
begin

for i in 1..1000000
loop
    select * into dolg2 from dolgozo where dkod = 2 for update;

    select * into dolg from dolgozo where dkod = 1 for update;    
    rollback;
end  loop;  
end;