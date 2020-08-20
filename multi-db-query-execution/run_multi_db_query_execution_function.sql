--The query will run the 2 create table scripts on 3 databases (postgres,admin,qc)
select multi_db_query_execution_function('postgres', 'postgres', 'postgres;admin;qc', 
'
create table temp_table1 (temp_table_id BIGINT not null primary key);
create table temp_table2 (temp_table_id BIGINT not null primary key)
');