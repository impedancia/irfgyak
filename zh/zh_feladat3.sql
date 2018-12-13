--select * from nikovits.dolgozo;--
--/
create or replace PROCEDURE ado
(
  p_szazalek IN NUMBER 
) AS 
 PRAGMA AUTONOMOUS_TRANSACTION;
    dolgozo_count number;
    counter NUMBER;
    hiba BOOLEAN;
    atutalas_exception EXCEPTION;
    fizetes NUMBER;
    cursor dolgozoCursor is
        SELECT *
        FROM bankszamla
        where tulajdonos not in ('Kincstar','Bolt','Munkahely');
    pragma exception_init(atutalas_exception,-20001);
BEGIN
    counter :=0;
    FOR dolgozo_rec in dolgozoCursor
    LOOP
        SELECT fizetes into fizetes from NIKOVITS.DOLGOZO d WHERE d.dnev =  dolgozo_rec.tulajdonos;
        hiba := true;
        while hiba = true 
        loop
            begin
                begin
                    counter := counter + 1;
                    update bankszamla set egyenleg = egyenleg - (fizetes * (p_szazalek/100)) where tulajdonos = dolgozo_rec.tulajdonos;
                    hiba := false;
                exception
                    when atutalas_exception then
                        hiba := true;
                        rollback;
                end;
                
                if hiba = false then
                    begin
                        counter := counter + 1;
                        update bankszamla set egyenleg = egyenleg + (fizetes * (p_szazalek/100)) where tulajdonos = 'Kincstar';
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
END ado;

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
-- Ellenõrizzük a kezdeti egyenlegek összegét. Ennek nem szabad változnia az átutalások során.
SELECT sum(egyenleg) FROM bankszamla;     
/
set serveroutput on
begin
    for i in 1..3 loop
       ado(10);
    end loop;
end;    
/
SELECT sum(egyenleg) FROM bankszamla;     
select * from bankszamla;

/*

Procedure ADO compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
53/5      PLS-00113: a(z) 'JUTALOM' END azonosítónak illeszkedni kell 'ADO'-hez/hoz: '1'.sor, 11.oszlop
Errors: check compiler log

Table BANKSZAMLA dropped.


Table BANKSZAMLA created.


1 row inserted.


1 row inserted.


1 row inserted.


Commit complete.


Trigger BANKSZAMLA_TRG compiled


SUM(EGYENLEG)
-------------
      1904250


Error starting at line : 87 in command -
begin
    for i in 1..3 loop
       ado(10);
    end loop;
end;
Error report -
ORA-06550: 3 sor, 8 oszlop:
PLS-00905: A(z) E9QZF1.ADO objektum érvénytelen
ORA-06550: 3 sor, 8 oszlop:
PL/SQL: Statement ignored
06550. 00000 -  "line %s, column %s:\n%s"
*Cause:    Usually a PL/SQL compilation error.
*Action:

SUM(EGYENLEG)
-------------
      1904250


TULAJDONOS                       EGYENLEG
------------------------------ ----------
SMITH                                8000
ALLEN                               16000
WARD                                12500
JONES                               29750
MARTIN                              12500
BLAKE                               42500
CLARK                               24500
SCOTT                               30000
KING                                50000
TURNER                              15000
ADAMS                               11000

TULAJDONOS                       EGYENLEG
------------------------------ ----------
JAMES                                9500
FORD                                30000
MILLER                              13000
Kincstar                          1000000
Munkahely                          500000
Bolt                               100000

17 rows selected. 


Procedure ADO compiled


Table BANKSZAMLA dropped.


Table BANKSZAMLA created.


1 row inserted.


1 row inserted.


1 row inserted.


Commit complete.


Trigger BANKSZAMLA_TRG compiled


SUM(EGYENLEG)
-------------
      1904250

szükséges update-ek száma: 39
szükséges update-ek száma: 58
szükséges update-ek száma: 41


PL/SQL procedure successfully completed.


SUM(EGYENLEG)
-------------
      1904250


TULAJDONOS                       EGYENLEG
------------------------------ ----------
SMITH                                7760
ALLEN                               15520
WARD                                12125
JONES                             28857,5
MARTIN                              12125
BLAKE                               41225
CLARK                               23765
SCOTT                               29100
KING                                48500
TURNER                              14550
ADAMS                               10670

TULAJDONOS                       EGYENLEG
------------------------------ ----------
JAMES                                9215
FORD                                29100
MILLER                              12610
Kincstar                        1009127,5
Munkahely                          500000
Bolt                               100000

17 rows selected. 


Procedure ADO compiled


Table BANKSZAMLA dropped.


Table BANKSZAMLA created.


1 row inserted.


1 row inserted.


1 row inserted.


Commit complete.


Trigger BANKSZAMLA_TRG compiled


SUM(EGYENLEG)
-------------
      1904250

szükséges update-ek száma: 39
szükséges update-ek száma: 47
szükséges update-ek száma: 52


PL/SQL procedure successfully completed.


SUM(EGYENLEG)
-------------
      1904250


TULAJDONOS                       EGYENLEG
------------------------------ ----------
SMITH                                7760
ALLEN                               15520
WARD                                12125
JONES                             28857,5
MARTIN                              12125
BLAKE                               41225
CLARK                               23765
SCOTT                               29100
KING                                48500
TURNER                              14550
ADAMS                               10670

TULAJDONOS                       EGYENLEG
------------------------------ ----------
JAMES                                9215
FORD                                29100
MILLER                              12610
Kincstar                        1009127,5
Munkahely                          500000
Bolt                               100000

17 rows selected. 


Procedure ADO compiled


Table BANKSZAMLA dropped.


Table BANKSZAMLA created.


1 row inserted.


1 row inserted.


1 row inserted.


Commit complete.


Trigger BANKSZAMLA_TRG compiled


SUM(EGYENLEG)
-------------
      1904250

szükséges update-ek száma: 34
szükséges update-ek száma: 36
szükséges update-ek száma: 34


PL/SQL procedure successfully completed.


SUM(EGYENLEG)
-------------
      1904250


TULAJDONOS                       EGYENLEG
------------------------------ ----------
SMITH                                7760
ALLEN                               15520
WARD                                12125
JONES                             28857,5
MARTIN                              12125
BLAKE                               41225
CLARK                               23765
SCOTT                               29100
KING                                48500
TURNER                              14550
ADAMS                               10670

TULAJDONOS                       EGYENLEG
------------------------------ ----------
JAMES                                9215
FORD                                29100
MILLER                              12610
Kincstar                        1009127,5
Munkahely                          500000
Bolt                               100000

17 rows selected. 

*/
