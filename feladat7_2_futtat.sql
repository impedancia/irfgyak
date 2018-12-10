create or replace PROCEDURE NOT_SERIAL IS  
    PROCEDURE UPDATE_DOLGOZO1 AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        UPDATE dolgozo
        SET fizetes=fizetes*2
        WHERE dkod=1;
        COMMIT;
    END;
BEGIN
    set transaction isolation level serializable;
    UPDATE_DOLGOZO1;
    
    UPDATE dolgozo
    SET fizetes=fizetes*2 
    WHERE dkod=1;
END;

/
set serveroutput on
execute not_serial();