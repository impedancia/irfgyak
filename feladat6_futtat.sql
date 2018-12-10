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