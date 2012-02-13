--CREATE OR REPLACE FUNCTION dubsar.test(lang text default 'english') RETURNS VOID AS $$
--DECLARE
--	t_name TEXT := 'objects';
--	t_col TEXT := 'id';
--	t_count INTEGER := 0;
--BEGIN
--	EXECUTE 'SELECT count(' || t_col || ') FROM ' || t_name::regclass;
--END;
--$$ LANGUAGE plpgsql;

CREATE VIEW dubsar.hierarchies AS
with recursive hier(child, parent, depth) AS (
		select pgh.inhrelid, pgh.inhparent, 1
		from pg_inherits pgh
	union
		select pgh.inhrelid, h.parent, h.depth + 1
		from pg_inherits pgh, hier h
		where pgh.inhparent = h.child
)
select c1.relname child, c2.relname parent, i.depth
from hier i, pg_class c1, pg_class c2
where i.child = c1.oid and i.parent = c2.oid;

