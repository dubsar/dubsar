CREATE SCHEMA dubsar;

-- Subjects
CREATE TABLE dubsar.subject_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_subject_id() RETURNS integer
AS $$
DECLARE	
	new_id integer;
BEGIN
	INSERT INTO dubsar.subject_ids values(default) RETURNING id INTO new_id;
	RETURN new_id;
END;
$$ LANGUAGE plpgsql;
CREATE TABLE dubsar.subjects (id INTEGER PRIMARY KEY REFERENCES dubsar.subject_ids(id) DEFAULT dubsar.new_subject_id());

CREATE TABLE dubsar.people (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.subject_ids(id)) INHERITS(dubsar.subjects);
CREATE TABLE dubsar.institutions (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.subject_ids(id)) INHERITS(dubsar.subjects);

CREATE VIEW dubsar.subject_types AS SELECT p.relname, s.id FROM pg_catalog.pg_class p, dubsar.subjects s WHERE s.tableoid = p.oid;

-- Objects
CREATE TABLE dubsar.thing_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_thing_id() RETURNS integer
AS $$
DECLARE	
	new_id integer;
BEGIN
	INSERT INTO dubsar.thing_ids values(default) RETURNING id INTO new_id;
	RETURN new_id;
END;
$$ LANGUAGE plpgsql;
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

CREATE TABLE searches (
	item_id INTEGER,
	item_relation TEXT,
	item_descriptive_column TEXT,
	content tsvector,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)
)
INHERITS(dubsar.things);
CREATE INDEX search_idx ON dubsar.searches USING GIN(content);
CREATE TABLE dubsar.documents (content TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.thing_ids(id)) INHERITS(dubsar.media);

CREATE VIEW dubsar.thing_types AS SELECT p.relname, s.id FROM pg_catalog.pg_class p, dubsar.things s WHERE s.tableoid = p.oid;

-- Properties
CREATE TABLE dubsar.property_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_property_id() RETURNS integer
AS $$
DECLARE	
	new_id integer;
BEGIN
	INSERT INTO dubsar.property_ids values(default) RETURNING id INTO new_id;
	RETURN new_id;
END;
$$ LANGUAGE plpgsql;
CREATE TABLE dubsar.properties (
	id INTEGER PRIMARY KEY DEFAULT dubsar.new_property_id(),
	subject_id INTEGER NOT NULL,
	thing_id INTEGER NOT NULL,
	UNIQUE (subject_id, thing_id),
	FOREIGN KEY(id) REFERENCES dubsar.property_ids(id),
	FOREIGN KEY(subject_id) REFERENCES dubsar.subject_ids(id),
	FOREIGN KEY(thing_id) REFERENCES dubsar.thing_ids(id)
);
CREATE TABLE dubsar.emailables (
	LIKE dubsar.properties INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES,
	FOREIGN KEY(id) REFERENCES dubsar.property_ids(id),
	FOREIGN KEY(subject_id) REFERENCES dubsar.subject_ids(id),
	FOREIGN KEY(thing_id) REFERENCES dubsar.thing_ids(id)
)
INHERITS(dubsar.properties);


CREATE VIEW dubsar.property_types AS SELECT pg_c.relname, p.id FROM pg_catalog.pg_class pg_c, dubsar.properties p WHERE p.tableoid = pg_c.oid;

-- APPLICATION TOOLS
CREATE TABLE dubsar.users(id SERIAL PRIMARY KEY, email TEXT UNIQUE, password_digest TEXT);

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

