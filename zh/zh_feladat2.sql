CREATE OR REPLACE FUNCTION zh_ktg_osszeg (
  vals VARCHAR2
) RETURN NUMBER
AS
    total number;
BEGIN
    with t as (
    select regexp_substr(vals,'[^,]+', 1, level) ktg from dual
    connect by regexp_substr(vals, '[^,]+', 1, level) is not null)
    select sum(ktg) into total from t;
  return total;
END;

/

CREATE OR REPLACE PROCEDURE zh_min_koltseg(p_hova varchar2) AS
BEGIN
  DECLARE
    CURSOR jarat_cursor IS
      WITH ktgek AS (
      SELECT     CONNECT_BY_ROOT honnan as honnan,
                 hova,
                 zh_ktg_osszeg(SYS_CONNECT_BY_PATH(koltseg, ',')) ossz_ktg
                 --(with t as (
                 --   select regexp_substr(vals,'[^,]+', 1, level) ktg from dual
                 --   connect by regexp_substr(vals, '[^,]+', 1, level) is not null)
                 --   select  sum(ktg) into total from t where rownum = 1) ossz_ktg
      FROM       NIKOVITS.EL
      WHERE      CONNECT_BY_ROOT honnan <> hova
      CONNECT BY NOCYCLE PRIOR hova = honnan
      )
      SELECT
            honnan,
            hova,
            MIN(ossz_ktg)
      FROM ktgek
      WHERE hova = p_hova
      GROUP BY honnan, hova;
      
      v_honnan NIKOVITS.EL.honnan%TYPE;
      v_hova NIKOVITS.EL.hova%TYPE;
      v_legkisebb_ktg NIKOVITS.EL.koltseg%TYPE;
  BEGIN
    OPEN jarat_cursor;    
    LOOP
      FETCH jarat_cursor INTO v_honnan, v_hova, v_legkisebb_ktg;
      EXIT WHEN jarat_cursor%NOTFOUND;
      
      dbms_output.put_line(v_honnan || ' -> ' || v_hova || ': ' || v_legkisebb_ktg);
      
    END LOOP;
    
    CLOSE jarat_cursor;
  END;
END;
/
set serveroutput on;
execute zh_min_koltseg('F')
/*

Function ZH_KTG_OSSZEG compiled


Procedure ZH_MIN_KOLTSEG compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
26/14     PLS-00201: 'NIKOVITS.HOVA' azonosítót deklarálni kell
26/14     PL/SQL: Item ignored
31/7      PL/SQL: SQL Statement ignored
31/41     PLS-00320: a kifejezés típusának deklarációja nemteljes vagy hibás
34/7      PL/SQL: Statement ignored
34/50     PLS-00320: a kifejezés típusának deklarációja nemteljes vagy hibás
Errors: check compiler log

Function ZH_KTG_OSSZEG compiled


Procedure ZH_MIN_KOLTSEG compiled


Function ZH_KTG_OSSZEG compiled


Procedure ZH_MIN_KOLTSEG compiled


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.

C -> F: 3600
E -> F: 2000
A -> F: 5100
D -> F: 3000
B -> F: 4100


PL/SQL procedure successfully completed.


Function ZH_KTG_OSSZEG compiled


Procedure ZH_MIN_KOLTSEG compiled

C -> F: 3600
E -> F: 2000
A -> F: 5100
D -> F: 3000
B -> F: 4100


PL/SQL procedure successfully completed.

*/