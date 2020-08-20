CREATE OR REPLACE FUNCTION multi_db_query_execution_function(username TEXT, password TEXT, databases TEXT, sqlscript TEXT)
RETURNS void AS $$
DECLARE    

	v_database_array TEXT[];
	v_script_array TEXT[];
    
 BEGIN
 
	v_database_array = string_to_array(databases,';');
	v_script_array = string_to_array(sqlscript,';');	
    
	BEGIN
		CREATE EXTENSION dblink;
		RAISE INFO 'dblink created!!';		
	EXCEPTION WHEN others THEN
		RAISE NOTICE 'Error occured to create dblink: % %', SQLERRM, SQLSTATE;
    END;

    FOR j IN 1 .. array_upper(v_database_array, 1)
    LOOP
		
		BEGIN		
			PERFORM dblink_connect('dbname='||v_database_array[j]||' user='||username||' password='||password||' port=5432');
			RAISE INFO 'Database: % connected',v_database_array[j];
			
			BEGIN			
			   FOR i IN 1 .. array_upper(v_script_array, 1)
			   LOOP
			   
					BEGIN
						PERFORM dblink_exec(v_script_array[i]);
						RAISE INFO 'Script executed: %',v_script_array[i];						
					EXCEPTION WHEN others THEN
						RAISE NOTICE 'Error occured to while executing the script % % %',v_script_array[i],SQLERRM, SQLSTATE;
					END;
					
			   END LOOP;
			EXCEPTION WHEN others THEN
				RAISE NOTICE 'Error occured to while splitting scripts. % %', SQLERRM, SQLSTATE;
			END;
			
		EXCEPTION WHEN others THEN
			RAISE NOTICE 'Error occured to while connecting to  DB:% % %',v_database_array[j], SQLERRM, SQLSTATE;
		END;
    END LOOP;
END;
$$
LANGUAGE plpgsql;