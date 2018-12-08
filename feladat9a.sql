CREATE OR REPLACE PROCEDURE hova(p_honnan varchar2) AS
BEGIN
  DECLARE
    CURSOR jarat_cursor IS
      SELECT DISTINCT p_honnan || ' -> ' || hova FROM jaratok
      WHERE hova <> p_honnan
      START WITH honnan = p_honnan
      CONNECT BY NOCYCLE PRIOR hova = honnan;
      sor varchar2(32767);
  BEGIN
    OPEN jarat_cursor;
    LOOP
      FETCH jarat_cursor INTO sor;
      EXIT WHEN jarat_cursor%NOTFOUND;
      dbms_output.put_line(sor);
    END LOOP;
    CLOSE jarat_cursor;
  END;
END;