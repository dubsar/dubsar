-- Properties
CREATE TABLE dubsar.property_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_property_id() RETURNS integer
AS $$
	INSERT INTO dubsar.property_ids values(default) RETURNING id;
$$ LANGUAGE sql;
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

