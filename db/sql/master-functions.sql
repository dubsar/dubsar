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

CREATE OR REPLACE FUNCTION dubsar.add_to_searches() RETURNS TRIGGER AS $$
DECLARE
	column_name TEXT := TG_ARGV[0];
	description TEXT := '';
BEGIN
	IF TG_NARGS = 2 THEN
		EXECUTE 'SELECT ($1).' || TG_ARGV[1] || '::text' INTO description USING NEW;
	ELSE
		EXECUTE 'SELECT substr(($1).' || TG_ARGV[0] || '::text, 0, 100)' INTO description USING NEW;
	END IF;
	EXECUTE
		'INSERT INTO dubsar.searches(item_id, item_relation, content, description) VALUES(
			$1.id,
			$2,
			to_tsvector($1.'||column_name||'),
			$3
		)'
	USING NEW, TG_TABLE_NAME, description;
	RETURN NULL;
END
$$ LANGUAGE plpgsql;
CREATE TRIGGER video_search
	AFTER INSERT OR UPDATE
	ON dubsar.youtube_videos
	FOR EACH ROW
	EXECUTE PROCEDURE dubsar.add_to_searches(description, title);

