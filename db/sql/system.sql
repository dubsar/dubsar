CREATE TABLE dubsar.system_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_system_id() RETURNS bigint
AS $$
	INSERT INTO system_ids values(default) RETURNING id;
	SELECT currval('system_ids_id_seq');
$$ LANGUAGE sql;

CREATE TABLE dubsar.systems (id INTEGER PRIMARY KEY REFERENCES dubsar.system_ids(id) DEFAULT dubsar.new_system_id());

CREATE TABLE dubsar.users(
	email TEXT UNIQUE,
	roles_mask INTEGER,
	crypted_password TEXT,
	salt TEXT,
	remember_me_token TEXT,
	remember_me_token_expires_at TIMESTAMP,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.system_ids(id)
)
INHERITS(dubsar.systems);

CREATE TABLE dubsar.roles(
	name VARCHAR(255) UNIQUE,
	enabled	BOOLEAN DEFAULT TRUE,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.system_ids(id)

)
INHERITS(dubsar.systems);

CREATE TABLE dubsar.capabilities(
	user_id BIGINT,
	role_id BIGINT,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.system_ids(id)
)
INHERITS(dubsar.systems);

