-- Entities

CREATE TABLE dubsar.entity_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_entity_id() RETURNS bigint
AS $$
	INSERT INTO entity_ids values(default) RETURNING id;
	SELECT currval('entity_ids_id_seq');
$$ LANGUAGE sql;
CREATE TABLE dubsar.entities (id INTEGER PRIMARY KEY REFERENCES dubsar.entity_ids(id) DEFAULT dubsar.new_entity_id());

CREATE TABLE dubsar.people (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.entity_ids(id)) INHERITS(dubsar.entities);
CREATE TABLE dubsar.institutions (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES dubsar.entity_ids(id)) INHERITS(dubsar.entities);

-- ?
-- CREATE VIEW dubsar.entity_types AS SELECT p.relname, s.id FROM pg_catalog.pg_class p, dubsar.entities s WHERE s.tableoid = p.oid;
