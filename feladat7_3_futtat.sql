create or replace procedure lock_test(p1 varchar2, p2 varchar2) is
    base_sql varchar2(1000);
    base2_sql varchar2(1000);
    mode1_sql varchar2(128);
    mode2_sql varchar2(128);
    exec_sql varchar2(128);
    FUNCTION conv(p varchar2) RETURN varchar2 is
        mode_sql varchar2(128);
    BEGIN
        case p
            when 'RS' THEN mode_sql := 'ROW SHARE';
            when 'RX' THEN mode_sql := 'ROW EXCLUSIVE';
            when 'S' THEN mode_sql := 'SHARE';
            when 'SRX' THEN mode_sql := 'SHARE ROW EXCLUSIVE';
            when 'X' THEN mode_sql := 'EXCLUSIVE';
            ELSE raise_application_error(-20000 , 'érvénytelen mód'); 
        end case; 
        return mode_sql;
    END;
    PROCEDURE another_lock(mode_sql varchar2) is
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        --EXECUTE IMMEDIATE  base2_sql USING mode_sql;
        dbms_output.Put_line('sql2: ' || utl_lms.format_message(base_sql, mode_sql));
        EXECUTE IMMEDIATE  utl_lms.format_message(base_sql, mode_sql);
        commit;
    END;
BEGIN
    base2_sql := 'LOCK TABLE dolgozo IN :1 MODE';
    base_sql := 'LOCK TABLE dolgozo IN %s MODE';    
    mode1_sql := conv(p1);
    mode2_sql := conv(p2);
    
    exec_sql := utl_lms.format_message(base_sql, mode1_sql);
    dbms_output.Put_line('mode1_sql: ' || mode1_sql);
    dbms_output.Put_line('mode2_sql: ' || mode2_sql);
    dbms_output.Put_line('sql1: ' || exec_sql);
    --EXECUTE IMMEDIATE base2_sql USING mode1_sql;
    EXECUTE IMMEDIATE exec_sql;
    begin
        
            another_lock(mode2_sql);    
            commit;
        dbms_output.put_line('OK');
    exception
        when others then
            dbms_output.put_line('NEM');
            dbms_output.put_line(sqlcode||' -- '||sqlerrm);
    end; 
    rollback;
END;
/
set serveroutput on;
execute lock_test('X', 'S');
execute lock_test('RS', 'S');
