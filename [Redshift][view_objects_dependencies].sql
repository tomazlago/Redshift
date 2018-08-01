/*
    Script to find object dependencies in AWS Redshift

    Author:     Tomaz Lanfredi Lago
    Date:       August, 01, 2018
*/

SELECT DISTINCT
	  dependent_ns.nspname AS dependent_schema
	, dependent_view.relname AS dependent_view 
	, source_ns.nspname AS source_schema
	, source_table.relname AS source_table
	, attribute.attname AS depend_attname
FROM pg_depend AS depend
	INNER JOIN pg_rewrite AS rewrite
		ON depend.objid = rewrite.oid 
	INNER JOIN pg_class AS dependent_view 
		ON rewrite.ev_class = dependent_view.oid 
	INNER JOIN pg_class AS source_table 
		ON depend.refobjid = source_table.oid 
	INNER JOIN pg_attribute AS attribute
		ON  depend.refobjid = attribute.attrelid 
	    AND depend.refobjsubid = attribute.attnum 
	INNER JOIN pg_namespace AS dependent_ns 
		ON dependent_ns.oid = dependent_view.relnamespace
	INNER JOIN pg_namespace AS source_ns 	
		ON source_ns.oid = source_table.relnamespace
ORDER BY dependent_ns.nspname
	, dependent_view.relname
;