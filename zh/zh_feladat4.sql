select * from tr_dolg;
select * from tr_oszt;
/
drop table tr_dolg;
CREATE TABLE tr_dolg(dkod,dnev,foglalkozas,fonoke,belepes,fizetes,jutalek,oazon) AS
SELECT * FROM nikovits.tr_dolg;
/
drop table tr_oszt;
CREATE TABLE tr_oszt(oazon,onev,telephely,osszfiz) AS
SELECT * FROM nikovits.tr_oszt;
/

CREATE OR REPLACE TRIGGER trigger_tr_dolg 
BEFORE DELETE OR INSERT OR UPDATE ON TR_DOLG 
REFERENCING OLD AS REGI NEW AS UJ 
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    vanemar number;
BEGIN
    if (deleting) then
        update tr_oszt set osszfiz = osszfiz - :regi.fizetes where oazon = :regi.oazon;
        commit;
    end if;
    if (updating) then
        if (:regi.oazon <> :uj.oazon) then
            update tr_oszt set osszfiz = osszfiz - :regi.fizetes where oazon = :regi.oazon;
            commit;
            update tr_oszt set osszfiz = osszfiz + :uj.fizetes where oazon = :uj.oazon;
            commit;
        else
            update tr_oszt set osszfiz = osszfiz - :regi.fizetes where oazon = :regi.oazon;
            commit;
            update tr_oszt set osszfiz = osszfiz + :uj.fizetes where oazon = :regi.oazon;
            commit;
        end if;
    end if;    
    if (inserting) then
        select count(*) into vanemar from tr_oszt where oazon = :uj.oazon;
        if (vanemar > 0) then
            update tr_oszt set osszfiz = osszfiz + :uj.fizetes where oazon = :uj.oazon;
            commit;
        else
            insert into tr_oszt (oazon, osszfiz) values (:uj.oazon, :uj.fizetes);
            commit;
        end if;
    end if;
END;


/
update tr_dolg set fizetes=fizetes+1 where dnev='KING';
delete from tr_dolg where dnev='SCOTT';
update tr_dolg set oazon=40 where dnev ='JAMES';
insert into tr_dolg (dkod, dnev, oazon, fizetes) values (1, 'BUBU', 50, 333);
/
select * from tr_dolg;
select * from tr_oszt;

/*

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


Table TR_DOLG created.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


Error starting at line : 2 in command -
CREATE TABLE tr_dolg(dkod,dnev,foglalkozas,fonoke,belepes,fizetes,jutalek,oazon) AS
SELECT * FROM nikovits.tr_dolg
Error report -
ORA-00955: a nevet már használja egy létezõ objektum.
00955. 00000 -  "name is already used by an existing object"
*Cause:    
*Action:

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


Table TR_DOLG dropped.


Table TR_DOLG created.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Error starting at line : 9 in command -
drop table tr_oszt
Error report -
ORA-00942: a tábla vagy a nézet nem létezik
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:

Table TR_OSZT created.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
5/9       PL/SQL: SQL Statement ignored
5/36      PL/SQL: ORA-00927: hiányzik az egyenlõségjel
Errors: check compiler log

Error starting at line : 41 in command -
update tr_dolg set fizetes=fizetes+1 where dnev='KING'
Error at Command Line : 41 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 42 in command -
delete from tr_dolg where dnev='SCOTT'
Error at Command Line : 42 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 43 in command -
update tr_dolg set oazon=40 where dnev ='JAMES'
Error at Command Line : 43 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 44 in command -
insert into tr_dolg (dkod, dnev, oazon, fizetes) values (1, 'BUBU', 50, 333)
Error at Command Line : 44 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


Error starting at line : 42 in command -
delete from tr_dolg where dnev='SCOTT'
Error report -
ORA-06519: a rendszer aktív önálló tranzakciót talált és visszagörgette
ORA-06512: a(z) "E9QZF1.TRIGGER_TR_DOLG", helyen a(z) 20. sornál
ORA-04088: hiba a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger futása közben


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


Error starting at line : 42 in command -
delete from tr_dolg where dnev='SCOTT'
Error report -
ORA-06519: a rendszer aktív önálló tranzakciót talált és visszagörgette
ORA-06512: a(z) "E9QZF1.TRIGGER_TR_DOLG", helyen a(z) 20. sornál
ORA-04088: hiba a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger futása közben


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
36/1      PLS-00103: "END" szimbólum szerepel 
Errors: check compiler log

Error starting at line : 56 in command -
update tr_dolg set fizetes=fizetes+1 where dnev='KING'
Error at Command Line : 56 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 57 in command -
delete from tr_dolg where dnev='SCOTT'
Error at Command Line : 57 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 58 in command -
update tr_dolg set oazon=40 where dnev ='JAMES'
Error at Command Line : 58 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 59 in command -
insert into tr_dolg (dkod, dnev, oazon, fizetes) values (1, 'BUBU', 50, 333)
Error at Command Line : 59 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS                  
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
22/68     PLS-00049: rossz hozzárendelt változó: 'UJ.OKOD'
27/61     PLS-00049: rossz hozzárendelt változó: 'UJ.OKOD'
Errors: check compiler log

Error starting at line : 66 in command -
update tr_dolg set fizetes=fizetes+1 where dnev='KING'
Error at Command Line : 66 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 67 in command -
delete from tr_dolg where dnev='SCOTT'
Error at Command Line : 67 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 68 in command -
update tr_dolg set oazon=40 where dnev ='JAMES'
Error at Command Line : 68 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 69 in command -
insert into tr_dolg (dkod, dnev, oazon, fizetes) values (1, 'BUBU', 50, 333)
Error at Command Line : 69 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
27/61     PLS-00049: rossz hozzárendelt változó: 'UJ.OKOD'
Errors: check compiler log

Error starting at line : 52 in command -
update tr_dolg set fizetes=fizetes+1 where dnev='KING'
Error at Command Line : 52 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 53 in command -
delete from tr_dolg where dnev='SCOTT'
Error at Command Line : 53 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 54 in command -
update tr_dolg set oazon=40 where dnev ='JAMES'
Error at Command Line : 54 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 55 in command -
insert into tr_dolg (dkod, dnev, oazon, fizetes) values (1, 'BUBU', 50, 333)
Error at Command Line : 55 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled

LINE/COL  ERROR
--------- -------------------------------------------------------------
22/13     PL/SQL: SQL Statement ignored
22/61     PL/SQL: ORA-00904: "OKOD": érvénytelen azonosító
27/17     PL/SQL: SQL Statement ignored
27/38     PL/SQL: ORA-00904: "OKOD": érvénytelen azonosító
Errors: check compiler log

Error starting at line : 52 in command -
update tr_dolg set fizetes=fizetes+1 where dnev='KING'
Error at Command Line : 52 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 53 in command -
delete from tr_dolg where dnev='SCOTT'
Error at Command Line : 53 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 54 in command -
update tr_dolg set oazon=40 where dnev ='JAMES'
Error at Command Line : 54 Column : 8
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

Error starting at line : 55 in command -
insert into tr_dolg (dkod, dnev, oazon, fizetes) values (1, 'BUBU', 50, 333)
Error at Command Line : 55 Column : 13
Error report -
SQL Error: ORA-04098: a(z) 'E9QZF1.TRIGGER_TR_DOLG' trigger érvénytelen, és az újraérvényesítés nem sikerült
04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7788 SCOTT      ANALYST         7566 82-DEC-09       3000                    20
      7839 KING       PRESIDENT            81-NOV-17       5000                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7900 JAMES      CLERK           7698 81-DEC-03        950                    30
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8750
        20 RESEARCH       DALLAS             10875
        30 SALES          CHICAGO            10800
        40 OPERATIONS     BOSTON                 0


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950
        50                                     333


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950
        50                                     333


Table TR_DOLG dropped.


Table TR_DOLG created.


Table TR_OSZT dropped.


Table TR_OSZT created.


Trigger TRIGGER_TR_DOLG compiled


1 row updated.


1 row deleted.


1 row updated.


1 row inserted.


      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 80-DEC-17        800                    20
      7499 ALLEN      SALESMAN        7698 81-FEB-20       1600        300         30
      7521 WARD       SALESMAN        7698 81-FEB-22       1250        500         30
      7566 JONES      MANAGER         7839 81-APR-02       2975                    20
      7654 MARTIN     SALESMAN        7698 81-SEP-28       1250       1400         30
      7698 BLAKE      MANAGER         7839 81-MAY-01       4250                    30
      7782 CLARK      MANAGER         7839 81-JUN-09       2450        200         10
      7839 KING       PRESIDENT            81-NOV-17       5001                    10
      7844 TURNER     SALESMAN        7698 81-SEP-08       1500         10         30
      7876 ADAMS      CLERK           7788 83-JAN-12       1100                    20
      7900 JAMES      CLERK           7698 81-DEC-03        950                    40

      DKOD DNEV       FOGLALKOZ     FONOKE BELEPES      FIZETES    JUTALEK      OAZON
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7902 FORD       ANALYST         7566 81-DEC-03       3000        700         20
      7934 MILLER     CLERK           7782 82-JAN-23       1300        600         10
         1 BUBU                                             333                    50

14 rows selected. 


     OAZON ONEV           TELEPHELY        OSSZFIZ
---------- -------------- ------------- ----------
        10 ACCOUNTING     NEW YORK            8751
        20 RESEARCH       DALLAS              7875
        30 SALES          CHICAGO             9850
        40 OPERATIONS     BOSTON               950
        50                                     333

*/