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

/

DROP TABLE bankszamla;

/

CREATE TABLE bankszamla(tulajdonos, egyenleg) AS
SELECT CAST(dnev AS VARCHAR(30)), CAST(fizetes*10 AS NUMBER) FROM nikovits.dolgozo;
INSERT INTO bankszamla VALUES('Kincstar', 1000000);
INSERT INTO bankszamla VALUES('Munkahely', 500000);
INSERT INTO bankszamla VALUES('Bolt', 100000);
COMMIT;

/

CREATE OR REPLACE TRIGGER bankszamla_trg
  BEFORE UPDATE ON bankszamla
  FOR EACH ROW
DECLARE
  v_szam INTEGER;
BEGIN
  v_szam := round(dbms_random.value(1,100));
  IF mod(v_szam, 5) = 0 THEN raise_application_error('-20001', 'Hiba'); END IF;
END;

/
-- Ellenőrizzük a kezdeti egyenlegek összegét. Ennek nem szabad változnia az átutalások során.
SELECT sum(egyenleg) FROM bankszamla;     
/
set serveroutput on
begin
    for i in 1..99 loop
       jutalom(1);
    end loop;
end;    
/
SELECT sum(egyenleg) FROM bankszamla;     
select * from bankszamla;