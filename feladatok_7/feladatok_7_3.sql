-- N5XGDH
-- 7/3
/*
Írjunk meg egy lock_test nevű procedúrát, amelyik LOCK TABLE utasítások kiadásával leteszteli, 
hogy két tranzakció a megadott két zárolási módban zárolhatja-e ugyanazt a táblát.
A második tranzakació egy autonóm tranzakcióként futó lokális procedúrában legyen megvalósítva.
A lehetséges zárolási módok: RS, RX, S, SRX, X.
A procedúra siker esetén írja ki, hogy OK, egyébként pedig, hogy NEM.

create or replace procedure lock_test(p1 varchar2, p2 varchar2) is ...
Tesztelés:
set serveroutput on
execute lock_test('RX', 'S');

Tipp!!!
A procedúra megírásához dinamikus SQL utasítást kell használni. Lásd pl_dinamikusSQL.txt
*/

create or replace procedure lock_test_autonomous(p varchar2) is
    md varchar2(123);
    v_str varchar2(2222);
    pragma autonomous_transaction;
begin 
    IF p = 'RS' THEN
        md := 'ROW SHARE MODE';
    ELSIF p = 'RX' THEN
        md := 'ROW EXCLUSIVE MODE';
    ELSIF p = 'S' THEN    
        md := 'SHARE MODE';
    ELSIF p = 'SRX' THEN    
        md := 'SHARE ROW MODE';
    ELSIF p = 'X' THEN   
        md := 'EXCLUSIVE MODE';
    ELSE
        md := 'ROW SHARE MODE';
    END IF;
    v_str :=  'LOCK TABLE TR_PROBA IN :x';
    EXECUTE IMMEDIATE v_str USING md;
end;

------

create or replace procedure lock_test(p1 varchar2, p2 varchar2) is
    res varchar2(512);
    md varchar2(123);
    v_str varchar2(2222);
begin
    begin
        LOCK_TEST_AUTONOMOUS(p1);
        IF p2 = 'RS' THEN
            md := 'ROW SHARE MODE';
        ELSIF p2 = 'RX' THEN
            md := 'ROW EXCLUSIVE MODE';
        ELSIF p2 = 'S' THEN    
            md := 'SHARE MODE';
        ELSIF p2 = 'SRX' THEN    
            md := 'SHARE ROW MODE';
        ELSIF p2 = 'X' THEN   
            md := 'EXCLUSIVE MODE';
        ELSE
            md := 'ROW SHARE MODE';
        END IF;
        v_str :=  'LOCK TABLE TR_PROBA IN :x';
        EXECUTE IMMEDIATE v_str USING md;
        dbms_output.put_line('OK');
    exception
        when others then
            dbms_output.put_line('NEM');
            dbms_output.put_line(sqlcode||' -- '||sqlerrm);
    end;
    rollback;
end;

