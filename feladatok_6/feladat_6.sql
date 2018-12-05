-- N5XGDH
-- 6
/* 
Elõkészítõ lépések. Ezeket a procedúra megírása elõtt le kell futtatni.
Készítsünk egy táblát, amely bankszámlák egyenlegét tartalmazza.
Minden dolgozónak kezdetben legyen az egyenlege a fizetésének a tízszerese.
A Munkahelynek is legyen egyenlege, a Kincstárnak is (ahová adót kell fizetni)
és egy Boltnak is, ahol vásárolni lehet.
A fenti lépéseket az alábbi utasítások végzik el.
*/
CREATE TABLE bankszamla(tulajdonos, egyenleg) AS
SELECT CAST(dnev AS VARCHAR(30)), CAST(fizetes*10 AS NUMBER) FROM nikovits.dolgozo;
INSERT INTO bankszamla VALUES('Kincstar', 1000000);
INSERT INTO bankszamla VALUES('Munkahely', 500000);
INSERT INTO bankszamla VALUES('Bolt', 100000);
COMMIT;
-- Ellenõrizzük a kezdeti egyenlegek összegét. Ennek nem szabad változnia az átutalások során.
SELECT sum(egyenleg) FROM bankszamla;      

/* Elõkészítés folytatása.
   Készítsünk egy triggert, ami egy bizonytalan végrehajtási környezetet
   szimulál, ami azt jelenti, hogy néha egy módosító utasítás nem fut le
   sikeresen, hanem kivételt dob. Generálunk egy véletlen számot, és ha 
   5-tel osztható, akkor legyen hiba.
*/
CREATE OR REPLACE TRIGGER bankszamla_trg
  BEFORE UPDATE ON bankszamla
  FOR EACH ROW
DECLARE
  v_szam INTEGER;
BEGIN
  v_szam := round(dbms_random.value(1,100));
  IF mod(v_szam, 5) = 0 THEN raise_application_error('-20001', 'Hiba'); END IF;
END;

/* A fenti környezetben készítsük el a JUTALOM nevû procedúrát, amely az egyenlegeket
   módosítja annak megfelelõen, hogy a munkahely minden dolgozónak egy adott összegû jutalmat ad.
   Minden dolgozó egyenlegét megnöveli az adott összeggel, a Munkahely egyenlegét pedig csökkenti.
   A procedúrának mindenképpen módosítania kell minden szükséges egyenleget, függetlenül attól, hogy
   mikor fordulnak elõ véletlen hibák a fenti trigger miatt. Ezeket az esetlegesen felmerülõ hibákat
   hibakezeléssel és tranzakció kezelõ utasítások (COMMIT/ROLLBACK) alkalmazásával kell orvosolnia.
   A procedúra a lefutása után írja ki, hogy összesen hány UPDATE mûveletet hajtott végre.
   (A sikeres és sikertelen mûveleteket is számoljuk bele.)

   CREATE OR REPLACE PROCEDURE jutalom(p_osszeg number) IS

   Futtassuk le ciklusban 99-szer a jutalom(1)-et, majd ellenõrizzük, hogy jók-e az egyenlegek.
   A ciklusban való futtatás után az új egyenlegeket is el kell küldeni.
*/


CREATE OR REPLACE PROCEDURE jutalom(p_osszeg number) IS   
    darab NUMBER;
BEGIN    
    FOR i IN 1..10000 LOOP
        BEGIN 
            SAVEPOINT start_pimpin;
            UPDATE bankszamla b 
            SET b.egyenleg = b.egyenleg + 1 
            WHERE b.tulajdonos NOT LIKE 'Munkahely' AND b.tulajdonos NOT LIKE 'Kincstar' AND b.tulajdonos NOT LIKE 'Bolt';
            COMMIT;
            EXIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO start_pimpin;
        END;
    END LOOP; 
    
    SELECT count(*) INTO darab FROM bankszamla b WHERE b.tulajdonos NOT LIKE 'Munkahely' AND b.tulajdonos NOT LIKE 'Kincstar' AND b.tulajdonos NOT LIKE 'Bolt';
    FOR i IN 1..10 LOOP
        BEGIN 
            SAVEPOINT start_deduction;
            UPDATE bankszamla b 
            SET b.egyenleg = b.egyenleg - darab
            WHERE b.tulajdonos LIKE 'Munkahely';
            COMMIT;
            EXIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO start_deduction;
        END;
    END LOOP;

END;
/



set SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE jutalom_runner IS
BEGIN
FOR i IN 1..99 LOOP
    jutalom(i);
END LOOP;
END;
/

exec jutalom_runner();