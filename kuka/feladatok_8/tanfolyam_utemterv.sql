-- N5XGDH
-- 8. feladat
-- Tanfolyam ütemterv (leírás 10. old.) egyszerűsítés: 1 tanfolyamot 1 oktató tart
-- (A Tanfolyam ütemterv és Oktatási ütemterv ugyanazt jelenti a leírásban.)

create or replace PROCEDURE TANFOLYAM_UTEMTERV IS
    ma DATE;
    most_honap VARCHAR2(128);
    last_month VARCHAR2(128);
    act_month VARCHAR2(128);
    tf_leiras VARCHAR2(128);
    tf_felelos VARCHAR2(128);
    tf_hely VARCHAR2(128);
    tf_oktato VARCHAR2(128);
    tf_max NUMBER;
    tf_ideigl NUMBER;
    tf_biztos NUMBER;
    tf_osszes NUMBER;
    tf_keszn NUMBER;
    tf_br NUMBER;
    tf_megj VARCHAR2(128);
BEGIN
    last_month := '0';
    
    SELECT CURRENT_DATE INTO ma FROM DUAL;
    SELECT to_char(ma, 'Month') INTO most_honap FROM dual;

    dbms_output.put_line('TANFOLYAM ÜTEMTERV');
    dbms_output.put_line(most_honap || EXTRACT(day FROM ma) || '-i állapot szerint');
    dbms_output.put_line(rpad('-', 160, '-'));
    dbms_output.put(rpad('| DÁT-', 15, ' '));
    dbms_output.put(rpad('| TANF', 12, ' '));
    dbms_output.put(rpad('| TANFOLYAM', 35, ' '));
    dbms_output.put(rpad('| TANF', 7, ' '));
    dbms_output.put(rpad('| TANFOLYAM', 15, ' '));
    dbms_output.put(rpad('| ELŐ-', 10, ' '));
    dbms_output.put(rpad('| KÜLDÖTTEK', 45, ' '));
    dbms_output.put(rpad('| MEGJ.', 20, ' '));
    dbms_output.put_line('|');
    dbms_output.put(rpad('| UM', 15, ' '));
    dbms_output.put(rpad('| KÓD', 12, ' '));
    dbms_output.put(rpad('| LEÍRÁS', 35, ' '));
    dbms_output.put(rpad('| FLŐS', 7, ' '));
    dbms_output.put(rpad('| HELYE', 15, ' '));
    dbms_output.put(rpad('| ADÓ', 10, ' '));
    dbms_output.put(rpad('| Max.', 9, ' '));
    dbms_output.put(rpad('| Ideigl.', 9, ' '));
    dbms_output.put(rpad('| Biztos', 9, ' '));
    dbms_output.put(rpad('| Össz.', 9, ' '));
    dbms_output.put(rpad('| Készn.', 9, ' '));
    dbms_output.put(rpad('|', 20, ' '));
    dbms_output.put_line('|');
    dbms_output.put_line(rpad('-', 160, '-'));
    
    FOR T IN (
        SELECT * FROM TANFOLYAM T ORDER BY T.KEZDODATUM
    )
    LOOP
        SELECT to_char(T.KEZDODATUM, 'Month') INTO act_month FROM dual;
        IF last_month != act_month THEN
            dbms_output.put(rpad(('| ' || act_month), 15, ' '));
            dbms_output.put(rpad('| ', 12, ' '));
            dbms_output.put(rpad('| ', 35, ' '));
            dbms_output.put(rpad('| ', 7, ' '));
            dbms_output.put(rpad('| ', 15, ' '));
            dbms_output.put(rpad('| ', 10, ' '));
            dbms_output.put(rpad('| ', 9, ' '));
            dbms_output.put(rpad('| ', 9, ' '));
            dbms_output.put(rpad('| ', 9, ' '));
            dbms_output.put(rpad('| ', 9, ' '));
            dbms_output.put(rpad('| ', 9, ' '));
            dbms_output.put(rpad('|', 20, ' '));
            dbms_output.put_line('|');
        END IF;
        SELECT to_char(T.KEZDODATUM, 'Month') INTO last_month FROM dual;
        SELECT TT.TIPUSNEV INTO tf_leiras FROM TTIPUS TT WHERE TT.TIPUSKOD = T.TIPUSKOD;
        SELECT TT.TANFFELELOS INTO tf_felelos FROM TTIPUS TT WHERE TT.TIPUSKOD = T.TIPUSKOD;
        SELECT H.NEV INTO tf_hely FROM HELYSZIN H WHERE H.HELYSZINKOD = T.HELYSZINKOD;
        SELECT OKTATOKOD INTO tf_oktato FROM OKTATOTANFOLYAM OT WHERE OT.TANFKOD = T.TANFKOD;
        SELECT TT.MAXLETSZAM INTO tf_max FROM TTIPUS TT WHERE TT.TIPUSKOD = T.TIPUSKOD;
        SELECT COUNT(*) INTO tf_ideigl FROM FOGLALAS F WHERE F.TANFKOD = T.TANFKOD AND F.STATUSZ LIKE '%Ideiglenes%';
        SELECT COUNT(*) INTO tf_biztos FROM FOGLALAS F WHERE F.TANFKOD = T.TANFKOD AND F.STATUSZ LIKE '%Megerositett%';
        SELECT COUNT(*) INTO tf_keszn FROM FOGLALAS F WHERE F.TANFKOD = T.TANFKOD AND F.STATUSZ LIKE '%Keszenlet%';
        SELECT COUNT(*) INTO tf_osszes FROM FOGLALAS F WHERE F.TANFKOD = T.TANFKOD;
        SELECT COUNT(*) INTO tf_br FROM BROSSURA B WHERE B.TANFKOD = T.TANFKOD;
        IF tf_br = 0 THEN
            tf_megj := 'Nincs a brossúrán';
        ELSE
            tf_megj := ' ';
        END IF;
        
        dbms_output.put(rpad(('| ' || EXTRACT(day FROM T.KEZDODATUM) || '-' || EXTRACT(day FROM T.VEGEDATUM)), 15, ' '));
        --dbms_output.put(rpad('| ', 12, ' '));
        dbms_output.put(rpad(('| ' || T.TANFKOD), 12, ' '));
        dbms_output.put(rpad(('| ' || tf_leiras), 35, ' '));
        dbms_output.put(rpad(('| ' || tf_felelos), 7, ' '));
        dbms_output.put(rpad(('| ' || tf_hely), 15, ' '));
        dbms_output.put(rpad(('| ' || tf_oktato), 10, ' '));
        dbms_output.put(rpad(('| ' || tf_max), 9, ' '));
        dbms_output.put(rpad(('| ' || tf_ideigl), 9, ' '));
        dbms_output.put(rpad(('| ' || tf_biztos), 9, ' '));
        dbms_output.put(rpad(('| ' || tf_osszes), 9, ' '));
        dbms_output.put(rpad(('| ' || tf_keszn), 9, ' '));
        dbms_output.put(rpad(('| ' || tf_megj), 20, ' '));
        dbms_output.put_line('|');
    END LOOP;
    dbms_output.put_line(rpad('-', 160, '-'));
END;

-- TESZT
execute TANFOLYAM_UTEMTERV;

-- OUTPUT

/*
TANFOLYAM ÜTEMTERV
December  2-i állapot szerint
----------------------------------------------------------------------------------------------------------------------------------------------------------------
| DÁT-         | TANF      | TANFOLYAM                        | TANF | TANFOLYAM    | ELŐ-    | KÜLDÖTTEK                                  | MEGJ.             |
| UM           | KÓD       | LEÍRÁS                           | FLŐS | HELYE        | ADÓ     | Max.   | Ideigl.| Biztos | Össz.  | Készn. |                   |
----------------------------------------------------------------------------------------------------------------------------------------------------------------
| Január       |           |                                  |      |              |         |        |        |        |        |        |                   |
| 15-19        | CSTJAN1   | Cégek stratégiai Tervezése       | GJ   | Piros ház    | GJ      | 10     | 2      | 10     | 12     | 2      |                   |
| 15-19        | EXSJAN1   | Exportáljunk a sikerért          | VD   | Zöld ház     | VD      | 10     | 0      | 6      | 6      | 0      |                   |
| 20-24        | STSJAN1   | Stratégiai tervezés              | GJ   | Fehér ház    | GJ      | 10     | 0      | 6      | 6      | 0      |                   |
| 20-24        | CSTJAN2   | Cégek stratégiai Tervezése       | GJ   | Piros ház    | NB      | 10     | 0      | 5      | 5      | 0      |                   |
| Február      |           |                                  |      |              |         |        |        |        |        |        |                   |
| 10-14        | KZSFEB1   | Közszereplés                     | VD   | Zöld ház     | VD      | 10     | 0      | 6      | 6      | 0      | Nincs a brossúrán |
| 15-19        | CSTFEB1   | Cégek stratégiai Tervezése       | GJ   | Piros ház    | KJ      | 10     | 0      | 5      | 5      | 0      |                   |
| 15-19        | EXSFEB1   | Exportáljunk a sikerért          | VD   | Zöld ház     | NB      | 10     | 0      | 5      | 5      | 0      |                   |
| 20-24        | STSFEB1   | Stratégiai tervezés              | GJ   | Fehér ház    | NB      | 10     | 3      | 3      | 6      | 0      | Nincs a brossúrán |
----------------------------------------------------------------------------------------------------------------------------------------------------------------

*/