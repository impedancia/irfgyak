create or replace PROCEDURE JUTALOM 
(
  p_osszeg IN NUMBER 
) AS 
 PRAGMA AUTONOMOUS_TRANSACTION;
    dolgozo_count number;
    counter NUMBER;
    hiba BOOLEAN;
    atutalas_exception EXCEPTION;
    cursor dolgozoCursor is
        SELECT *
        FROM bankszamla
        where tulajdonos not in ('Kincstar','Bolt','Munkahely');
    pragma exception_init(atutalas_exception,-20001);
BEGIN
    counter :=0;
    FOR dolgozo_rec in dolgozoCursor
    LOOP
        hiba := true;
        while hiba = true 
        loop
            begin
                begin
                    counter := counter + 1;
                    update bankszamla set egyenleg = egyenleg + p_osszeg where tulajdonos = dolgozo_rec.tulajdonos;
                    hiba := false;
                exception
                    when atutalas_exception then
                        hiba := true;
                        rollback;
                end;
                
                if hiba = false then
                    begin
                        counter := counter + 1;
                        update bankszamla set egyenleg = egyenleg - p_osszeg where tulajdonos = 'Munkahely';
                        hiba := false;
                    exception
                        when atutalas_exception then
                            hiba := true;
                            rollback;
                    end;
                end if;        
                if hiba = false then
                    commit;
                end if;
         end;       
        end loop;   
    END LOOP;
    dbms_output.Put_line('szükséges update-ek száma: ' || to_char(counter));
END JUTALOM;