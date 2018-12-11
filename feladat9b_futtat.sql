CREATE OR REPLACE FUNCTION ktg_osszeg (
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

CREATE OR REPLACE PROCEDURE min_koltseg(p_honnan varchar2) AS
BEGIN
  DECLARE
    CURSOR jarat_cursor IS
      WITH ktgek AS (
      SELECT     CONNECT_BY_ROOT honnan as honnan,
                 hova,
                 ktg_osszeg(SYS_CONNECT_BY_PATH(koltseg, ',')) ossz_ktg
                 --(with t as (
                 --   select regexp_substr(vals,'[^,]+', 1, level) ktg from dual
                 --   connect by regexp_substr(vals, '[^,]+', 1, level) is not null)
                 --   select  sum(ktg) into total from t where rownum = 1) ossz_ktg
      FROM       jaratok
      WHERE      CONNECT_BY_ROOT honnan <> hova
      CONNECT BY NOCYCLE PRIOR hova = honnan
      )
      SELECT
            honnan,
            hova,
            MIN(ossz_ktg)
      FROM ktgek
      WHERE honnan = p_honnan
      GROUP BY honnan, hova;
      
      v_honnan jaratok.honnan%TYPE;
      v_hova jaratok.hova%TYPE;
      v_legkisebb_ktg jaratok.koltseg%TYPE;
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
execute min_koltseg('San Francisco');