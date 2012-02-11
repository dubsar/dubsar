CREATE OR REPLACE FUNCTION dubsar.copy_to(path text) RETURNS VOID
AS $$
BEGIN
	FOR r IN
		SELECT relname
		FROM pg_class pc, pg_namespace ns, pg_type pt
		WHERE pc.relnamespace = ns.oid AND ns.nspname = 'dubsar' AND pc.relname = pt.typname
	LOOP
		NEXT r;
		EXECUTE 	
$$ LANGUAGE plpgsql;
