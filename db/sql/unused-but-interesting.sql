CREATE VIEW dubsar.type_hierarchies AS
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


CREATE OR REPLACE FUNCTION dubsar.add_to_searches(INT, TEXT, TEXT, TEXT) RETURNS INTEGER  AS $$
	INSERT INTO searches(item_id, item_relation, description, content) VALUES (
		$1,
		$2,
		substr(($3), 0, 100), 
		to_tsvector($4)
	);
	SELECT 1;
	$$ LANGUAGE sql;

CREATE OR REPLACE RULE youtube_videos_search AS 
	ON INSERT
	TO youtube_videos
	DO SELECT dubsar.add_to_searches(
		new.id - 1,
		'youtube_videos',
		new.title,
		new.description
	);
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
