-- DEPRECATED
-- PG powered search engine
CREATE TABLE dubsar.searches (
	item_id INTEGER,
	item_relation TEXT,
	item_descriptive_column TEXT,
	description TEXT,
	content tsvector,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)
)
INHERITS(dubsar.things);
CREATE INDEX search_idx ON dubsar.searches USING GIN(content);
CREATE TABLE dubsar.documents (content TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.media);

CREATE VIEW dubsar.thing_types AS SELECT p.relname, s.id FROM pg_catalog.pg_class p, dubsar.things s WHERE s.tableoid = p.oid;

CREATE OR REPLACE VIEW dubsar.tags AS
	SELECT ts_stat.word as "text", ts_stat.ndoc * ts_stat.nentry as "weight"
	FROM ts_stat('select content from searches'::text) ts_stat(word, ndoc, nentry)
	WHERE ts_stat.word !~~ '%.%'::text AND length(ts_stat.word) > 3
	ORDER BY ts_stat.ndoc DESC, ts_stat.nentry DESC;

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

