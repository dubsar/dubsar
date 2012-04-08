DROP TABLE IF EXISTS dubsar.name_ids CASCADE;
CREATE TABLE dubsar.name_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_name_id() RETURNS bigint
AS $$
	INSERT INTO name_ids values(default) RETURNING id;
	SELECT currval('name_ids_id_seq');
$$ LANGUAGE sql;

DROP TABLE IF EXISTS dubsar.names CASCADE;
CREATE TABLE dubsar.names (id INTEGER PRIMARY KEY REFERENCES dubsar.name_ids(id) DEFAULT dubsar.new_name_id());


DROP TABLE IF EXISTS dubsar.thing_names CASCADE;
CREATE TABLE dubsar.thing_names(
	name VARCHAR(255) UNIQUE,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.name_ids(id)
)
INHERITS(dubsar.names);

DROP TABLE IF EXISTS dubsar.entity_names CASCADE;
CREATE TABLE dubsar.entity_names(
	name VARCHAR(255) UNIQUE,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.name_ids(id)
)
INHERITS(dubsar.names);

DROP TABLE IF EXISTS dubsar.property_names CASCADE;
CREATE TABLE dubsar.property_names(
	name VARCHAR(255) UNIQUE,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.name_ids(id)
)
INHERITS(dubsar.names);

DROP TABLE IF EXISTS dubsar.property_links CASCADE;
CREATE TABLE dubsar.property_links(
	property_id INTEGER NOT NULL REFERENCES dubsar.property_names(id),
	entity_id INTEGER NOT NULL REFERENCES dubsar.entity_names(id),
	thing_id INTEGER NOT NULL REFERENCES dubsar.thing_names(id),
	PRIMARY KEY(id),
	UNIQUE(property_id, entity_id, thing_id),
	FOREIGN KEY(id) REFERENCES dubsar.name_ids(id)
)
INHERITS(dubsar.names);

