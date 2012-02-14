CREATE SCHEMA dubsar;
SET search_path TO public,dubsar;

-- Subjects
CREATE TABLE dubsar.entity_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_entity_id() RETURNS bigint
AS $$
	INSERT INTO entity_ids values(default) RETURNING id;
	SELECT currval('entity_ids_id_seq');
$$ LANGUAGE sql;
CREATE TABLE dubsar.entities (id INTEGER PRIMARY KEY REFERENCES dubsar.entity_ids(id) DEFAULT dubsar.new_entity_id());

CREATE TABLE dubsar.people (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.entity_ids(id)) INHERITS(dubsar.entities);
CREATE TABLE dubsar.institutions (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.entity_ids(id)) INHERITS(dubsar.entities);

CREATE VIEW dubsar.entity_types AS SELECT p.relname, s.id FROM pg_catalog.pg_class p, dubsar.entities s WHERE s.tableoid = p.oid;

-- Objects
CREATE TABLE dubsar.thing_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_thing_id() RETURNS bigint
AS $$
	INSERT INTO thing_ids values(default) RETURNING id;
	SELECT currval('thing_ids_id_seq');
$$ LANGUAGE sql;
CREATE TABLE dubsar.things (id INTEGER PRIMARY KEY REFERENCES dubsar.thing_ids(id) DEFAULT dubsar.new_thing_id());

CREATE TABLE dubsar.accounts (user_name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.things);
CREATE TABLE dubsar.youtube_accounts (checked DATE, UNIQUE(user_name), PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.accounts);
CREATE TABLE dubsar.emails (email TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.things);
CREATE TABLE dubsar.media (PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.things);
CREATE TABLE dubsar.videos (PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.media);
CREATE TABLE dubsar.youtube_videos (
	youtube_id TEXT,
	youtube_user_name TEXT,
	title TEXT,
	description TEXT,
	published DATE,
	updated DATE,
	PRIMARY KEY(id),
	UNIQUE(youtube_id),
	FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)
)
INHERITS(dubsar.videos);

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

-- APPLICATION TOOLS
CREATE TABLE dubsar.users(
	id SERIAL PRIMARY KEY,
	email TEXT UNIQUE,
	crypted_password TEXT,
	salt TEXT,
	remember_me_token TEXT,
	remember_me_token_expires_at TIMESTAMP
);


