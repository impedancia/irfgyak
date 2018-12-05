-- N5XGDH
-- 6
/* 
El�k�sz�t� l�p�sek. Ezeket a proced�ra meg�r�sa el�tt le kell futtatni.
K�sz�ts�nk egy t�bl�t, amely banksz�ml�k egyenleg�t tartalmazza.
Minden dolgoz�nak kezdetben legyen az egyenlege a fizet�s�nek a t�zszerese.
A Munkahelynek is legyen egyenlege, a Kincst�rnak is (ahov� ad�t kell fizetni)
�s egy Boltnak is, ahol v�s�rolni lehet.
A fenti l�p�seket az al�bbi utas�t�sok v�gzik el.
*/
CREATE TABLE bankszamla(tulajdonos, egyenleg) AS
SELECT CAST(dnev AS VARCHAR(30)), CAST(fizetes*10 AS NUMBER) FROM nikovits.dolgozo;
INSERT INTO bankszamla VALUES('Kincstar', 1000000);
INSERT INTO bankszamla VALUES('Munkahely', 500000);
INSERT INTO bankszamla VALUES('Bolt', 100000);
COMMIT;
-- Ellen�rizz�k a kezdeti egyenlegek �sszeg�t. Ennek nem szabad v�ltoznia az �tutal�sok sor�n.
SELECT sum(egyenleg) FROM bankszamla;      

/* El�k�sz�t�s folytat�sa.
   K�sz�ts�nk egy triggert, ami egy bizonytalan v�grehajt�si k�rnyezetet
   szimul�l, ami azt jelenti, hogy n�ha egy m�dos�t� utas�t�s nem fut le
   sikeresen, hanem kiv�telt dob. Gener�lunk egy v�letlen sz�mot, �s ha 
   5-tel oszthat�, akkor legyen hiba.
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

/* A fenti k�rnyezetben k�sz�ts�k el a JUTALOM nev� proced�r�t, amely az egyenlegeket
   m�dos�tja annak megfelel�en, hogy a munkahely minden dolgoz�nak egy adott �sszeg� jutalmat ad.
   Minden dolgoz� egyenleg�t megn�veli az adott �sszeggel, a Munkahely egyenleg�t pedig cs�kkenti.
   A proced�r�nak mindenk�ppen m�dos�tania kell minden sz�ks�ges egyenleget, f�ggetlen�l att�l, hogy
   mikor fordulnak el� v�letlen hib�k a fenti trigger miatt. Ezeket az esetlegesen felmer�l� hib�kat
   hibakezel�ssel �s tranzakci� kezel� utas�t�sok (COMMIT/ROLLBACK) alkalmaz�s�val kell orvosolnia.
   A proced�ra a lefut�sa ut�n �rja ki, hogy �sszesen h�ny UPDATE m�veletet hajtott v�gre.
   (A sikeres �s sikertelen m�veleteket is sz�moljuk bele.)

   CREATE OR REPLACE PROCEDURE jutalom(p_osszeg number) IS

   Futtassuk le ciklusban 99-szer a jutalom(1)-et, majd ellen�rizz�k, hogy j�k-e az egyenlegek.
   A ciklusban val� futtat�s ut�n az �j egyenlegeket is el kell k�ldeni.
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