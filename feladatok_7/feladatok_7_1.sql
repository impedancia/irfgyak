-- N5XGDH
-- 7/1
/* 
Adjuk meg két tranzakciónak egy olyan ütemezését, hogy DEADLOCK alakuljon ki.
Adjunk meg két konkrét SQL utasítássorozatot (két SqlDeveloper példány futtatásának segítségével) 
úgy, hogy DEADLOCK alakuljon ki, és ezt írja is ki a rendszer hibaüzenetként.
Valami ilyesmit kell kiírnia:
"ORA-60: deadlock detected while waiting for resource"
*/

CREATE TABLE DEDLOKK(
	"NAME" VARCHAR2(32) PRIMARY KEY, 
	"VALUE" NUMBER
	);

INSERT INTO DEDLOKK VALUES ('JANI', 5);
INSERT INTO DEDLOKK VALUES ('PISTI', 2);

/* SESSION 1 ******************************************/

DECLARE 
    VAL_1 DEDLOKK%ROWTYPE;
    VAL_2 DEDLOKK%ROWTYPE;
    R NUMBER;
BEGIN
	-- lockoljuk a PISTI-t
    SELECT *
    INTO VAL_2
    FROM DEDLOKK
    WHERE name LIKE 'PISTI'
    FOR UPDATE;
    
	-- húzzuk az időt, hogy a másik sessiont el tudjuk indítani
    FOR i in 1..5000000 LOOP
        R := dbms_random.value(1,100);
    END LOOP;
    
	-- lockoljuk a második táblát
    SELECT *
    INTO VAL_1
    FROM DEDLOKK
    WHERE name LIKE 'JANI'
    FOR UPDATE;
    
    ROLLBACK;
END;
/

/*******************************************/

/* SESSION 2 ******************************************/

DECLARE 
    VAL_1 DEDLOKK%ROWTYPE;
    VAL_2 DEDLOKK%ROWTYPE;
    R NUMBER;
BEGIN
    SELECT *
    INTO VAL_1
    FROM DEDLOKK
    WHERE name = 'JANI'
    FOR UPDATE;
    
    FOR i in 1..5000000 LOOP
        R := dbms_random.value(1,100);
    END LOOP;
    
    SELECT *
    INTO VAL_2
    FROM DEDLOKK
    WHERE name = 'PISTI'
    FOR UPDATE;
    
    ROLLBACK;
END;
/

/***************************************************/