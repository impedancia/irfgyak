-- N5XGDH
-- 8. feladat
-- Számla előállítása (leírás 16. old.) egyszerűsítés: törölt résztvevő is szerepel a számlán
--  (utólag majd jóváírással rendezzük)

create or replace PROCEDURE CR_SZAMLA (in_ugyfel IN VARCHAR2, in_tf IN VARCHAR2) IS
    szamlaszam NUMBER;
    szamla NUMBER;
    ma DATE;
    tkod VARCHAR2(128);
    tnev VARCHAR2(128);
    kezdes DATE;
    vege DATE;
    tandij NUMBER;
    ar NUMBER;
    kuldottek NUMBER;
    fokonyv NUMBER;
    kapcs VARCHAR2(128);
    honap VARCHAR2(128);
    most_honap VARCHAR2(128);
BEGIN
    kuldottek := 0;
    SELECT CURRENT_DATE INTO ma FROM DUAL;
    -- nezzuk meg letezik-e mar az adott ugyfelre es tanfolyamra gyartott szamla, ha nem, akkor hozzunk neki letre egy szamlaszamot
    SELECT count(*) INTO szamla FROM SZAMLA2 WHERE in_ugyfel LIKE UGYFELNEV AND in_tf LIKE TANFKOD;
    IF szamla = 0 THEN
        INSERT INTO SZAMLA2 VALUES (SZAMLA_SZAMLASZAM_SEQ.NEXTVAL, in_ugyfel, in_tf, ma);
    END IF;

    -- vegyuk elo a megfelelo szamlaszamot
    SELECT SZAMLASZAM INTO szamlaszam FROM SZAMLA2 WHERE in_ugyfel LIKE UGYFELNEV AND in_tf LIKE TANFKOD;

    -- vegyuk elo a kurzus adatokat
    SELECT TIPUSKOD INTO tkod FROM TANFOLYAM t WHERE t.TANFKOD like in_tf;
    SELECT KEZDODATUM INTO kezdes FROM TANFOLYAM t WHERE t.TANFKOD like in_tf;
    SELECT VEGEDATUM INTO vege FROM TANFOLYAM t WHERE t.TANFKOD like in_tf;
    SELECT TIPUSNEV INTO tnev FROM TTIPUS tt WHERE tt.TIPUSKOD like tkod;
    SELECT AR INTO ar FROM TTIPUS tt WHERE tt.TIPUSKOD like tkod;

    SELECT to_char(kezdes, 'Month') INTO honap FROM dual;
    SELECT to_char(ma, 'Month') INTO most_honap FROM dual;

    -- ugyfeladatok
    SELECT FOKONYVSZAM INTO fokonyv FROM UGYFEL WHERE UGYFELNEV = in_ugyfel;
    SELECT KAPCSTARTO INTO kapcs FROM UGYFEL WHERE UGYFELNEV = in_ugyfel;

    dbms_output.put_line('CRAMHEAD COLLEGE');
    dbms_output.put_line('Cramhead menedzserképző, Greymatter Ház, Braintree, Essex');
    dbms_output.put_line(rpad('Alapítva 1978-ban', 40, ' ') || 'Igazgató: N. Wisdom PhD');
    dbms_output.put_line('   Fawlty Tours Ltd.');
    dbms_output.put_line(rpad('   Holiday House', 40, ' ') || 'Számlaszám: ' || szamlaszam);
    dbms_output.put_line('   Letsby Avenue');
    dbms_output.put_line('   Basildon, Essex');
    dbms_output.put_line(rpad((kapcs || ' figyelmébe'), 40, ' ') || 'Dátum: ' || most_honap || ' ' || EXTRACT(day FROM ma) || '.');
    dbms_output.put_line('-----------------------------------------------------------------------');
    dbms_output.put_line(rpad((rpad('KURZUS: ', 25, ' ') || in_tf), 55) || '|' || rpad(' ', 15, ' ') || '|');
    dbms_output.put_line(rpad((rpad('KURZUS CÍM: ', 25, ' ') || tnev), 55) || '|' || rpad(' ', 15, ' ') || '|');
    dbms_output.put_line(rpad((rpad('KURZUS IDEJE: ', 25, ' ') || honap || ' ' || EXTRACT(day FROM kezdes) || '-' || EXTRACT(day FROM vege)), 55) || '|' || rpad(' ', 15, ' ') || '|');
    dbms_output.put_line(rpad((rpad('TANDÍJ: ', 25, ' ') || ar), 55) || '|' || rpad(' ', 15, ' ') || '|');
    dbms_output.put_line(rpad('KÜLDÖTTEK ', 55, ' ') || '|' || rpad(' ', 15, ' ') || '|');
    FOR K IN (
        SELECT * FROM FOGLALAS F WHERE F.UGYFELNEV = in_ugyfel AND F.TANFKOD = in_tf
    )
    LOOP
        kuldottek := kuldottek + 1;
        dbms_output.put_line( rpad((rpad(' ', 15, ' ') || K.RESZTVEVONEV), 55, ' ') || '|' || rpad(ar, 15, ' ') || '|');
    END LOOP;
    dbms_output.put_line(rpad(' ', 55, ' ') || '|' || rpad('-', 15, '-') || '|');
    dbms_output.put_line(rpad((rpad(' ', 35, ' ') || 'Netto összeg: '), 55, ' ') || '|'  || rpad(kuldottek * ar, 15, ' ') || '|');
    dbms_output.put_line(rpad((rpad(' ', 35, ' ') || 'ÁFA 17.5%:    '), 55, ' ') || '|'  || rpad(kuldottek * ar * 0.175, 15, ' ') || '|');
    dbms_output.put_line(rpad(('Ügyfél főkönyvi száma: ' || fokonyv), 55, ' ') || '|' || rpad('-', 15, '-') || '|');
    dbms_output.put_line(rpad((rpad(' ', 35, ' ') || 'Számla összeg: '), 55, ' ') || '|'  || rpad(kuldottek * ar * 1.175, 15, ' ') || '|');
    dbms_output.put_line('-----------------------------------------------------------------------');
END;


-- TESZT:
execute CR_SZAMLA ('Ugyfel2', 'CSTJAN1');

-- OUTPUT:

/*
CRAMHEAD COLLEGE
Cramhead menedzserképző, Greymatter Ház, Braintree, Essex
Alapítva 1978-ban                       Igazgató: N. Wisdom PhD
   Fawlty Tours Ltd.
   Holiday House                        Számlaszám: 2
   Letsby Avenue
   Basildon, Essex
Kapcs2 figyelmébe                       Dátum: December   2.
-----------------------------------------------------------------------
KURZUS:                  CSTJAN1                       |               |
KURZUS CÍM:              Cégek stratégiai Tervezése    |               |
KURZUS IDEJE:            Január     15-19              |               |
TANDÍJ:                  30000                         |               |
KÜLDÖTTEK                                              |               |
               Kiss Andrea                             |30000          |
               Kiss Elek                               |30000          |
               Kiss Gergely                            |30000          |
               Kiss Jakab                              |30000          |
               Kiss Tibor                              |30000          |
                                                       |---------------|
                                   Netto összeg:       |150000         |
                                   ÁFA 17.5%:          |26250          |
Ügyfél főkönyvi száma: 222                             |---------------|
                                   Számla összeg:      |176250         |
-----------------------------------------------------------------------
		
*/