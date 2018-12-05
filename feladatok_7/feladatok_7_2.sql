-- N5XGDH
-- 7/2
/*
Adjunk meg egy olyan ütemezést két tranzakcióra, amely nem sorbarendezhető.
Mindezt egy NOT_SERIAL nevű procedúra megírásával érjük el, amely egy autonóm tranzakcióként 
futó lokális procedúrát (vagyis nem tárolt procedúrát) hív meg.
Ha jól írtuk meg, akkor a procedúra a következő hibaüzenetet fogja kiírni:
"ORA-08177: can't serialize access for this transaction"

create or replace procedure not_serial is ...
Tesztelés:
set serveroutput on
execute not_serial();
*/

/* autonóm procedúra amit az izolált szerializálható tranzakcióból hívunk meg */
create or replace PROCEDURE UPDATE_JANI IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    UPDATE tr_proba
    SET szam=szam+1 
    WHERE sorsz=1;
    COMMIT;
END;
/* Procedúra vége */

/* Tranzakció */
set autocommit off;
set transaction isolation level serializable;
execute UPDATE_JANI;

UPDATE tr_proba
SET szam=szam+1 
WHERE sorsz=1;

-- EZ AZ UPDATE MIATT JELENTKEZIK ORA-08177

