drop function mely_tablak;
drop function get_endusers;
drop type username_table;
commit;

create or replace type username_table is table of varchar2(30);
/

create or replace function get_endusers (gr varchar2)
return username_table
is
    returntable username_table;
    returntable_sub username_table;
    grantee_is_role number;
    cursor cr_grantee is select grantee from dba_role_privs where granted_role = gr;    
begin
    returntable := username_table();    
    select count(*) into grantee_is_role from dba_roles dr where dr.role = gr;
    
    --its the public role
    if gr = 'PUBLIC' then
        select username bulk collect into returntable from sys.dba_users;
    --its a user
    elsif grantee_is_role = 0 then
        returntable.extend();
        returntable(returntable.count) := gr;
    --its a role
    else
        for crg in cr_grantee
        loop
            returntable_sub := get_endusers(crg.grantee);
            for idx in 1 .. returntable_sub.count
            loop
                returntable.extend();
                returntable(returntable.count) := returntable_sub(idx);
            end loop;
        end loop;
    end if;
    
    return returntable;
end get_endusers;
/

create or replace function mely_tablak (p_user varchar2) return varchar2
is
    --provided that orauser will not have a lot more table
    retval varchar2(2000);
    p_user_is_user number;
begin
    --check if p_user exists
    select count(*) into p_user_is_user from dba_users where username = upper(p_user);
    if p_user_is_user = 0 then
        retval := 'nem letezo user';
        return retval;
    end if;

    select listagg(table_name, ', ') within group (order by table_name) into retval
    from
        (select distinct table_name
        from
            (select dsp.grantee, t.table_name
            from dba_sys_privs dsp, (select table_name from dba_tables where owner='ORAUSER') t
            where privilege = 'INSERT ANY TABLE'
            union
            select grantee, table_name from dba_tab_privs
            where owner = 'ORAUSER' and privilege = 'INSERT') t cross apply (table(get_endusers(t.grantee))) u
            where u.column_value = upper(p_user)
            order by u.column_value);
        
    return retval;
end mely_tablak;