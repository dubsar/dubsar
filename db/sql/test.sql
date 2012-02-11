--CREATE OR REPLACE FUNCTION dubsar.test(lang text default 'english') RETURNS VOID AS $$
--DECLARE
--	t_name TEXT := 'objects';
--	t_col TEXT := 'id';
--	t_count INTEGER := 0;
--BEGIN
--	EXECUTE 'SELECT count(' || t_col || ') FROM ' || t_name::regclass;
--END;
--$$ LANGUAGE plpgsql;

/*
DROP VIEW dubsar.menus;

CREATE VIEW dubsar.menus AS
with recursive hier(child, parent, depth, path) AS (
		select pgh.inhrelid, pgh.inhparent, 1, cast(pgh.inhparent || '.' || pgh.inhrelid as text)
		from pg_inherits pgh
	union
		select pgh.inhrelid, h.parent, h.depth + 1, cast(h.path || '.' || pgh.inhparent || '.' || pgh.inhrelid as text)
		from pg_inherits pgh, hier h
		where pgh.inhparent = h.child
)
select c1.relname child, c2.relname parent, i.depth, i.path
from hier i, pg_class c1, pg_class c2
where i.child = c1.oid and i.parent = c2.oid
order by path;
*/

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
DROP TRIGGER video_search ON dubsar.youtube_videos;
CREATE TRIGGER video_search
	AFTER INSERT OR UPDATE
	ON dubsar.youtube_videos
	FOR EACH ROW
	EXECUTE PROCEDURE dubsar.add_to_searches(description, title);

