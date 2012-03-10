CREATE TABLE dubsar.practice_ids (id SERIAL PRIMARY KEY);
CREATE OR REPLACE FUNCTION dubsar.new_practice_id() RETURNS bigint
AS $$
	INSERT INTO practice_ids values(default) RETURNING id;
	SELECT currval('practice_ids_id_seq');
$$ LANGUAGE sql;
CREATE TABLE dubsar.practices (id INTEGER PRIMARY KEY REFERENCES dubsar.practice_ids(id) DEFAULT dubsar.new_practice_id());
CREATE TABLE dubsar.users(
	email TEXT UNIQUE,
	crypted_password TEXT,
	salt TEXT,
	remember_me_token TEXT,
	remember_me_token_expires_at TIMESTAMP,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.practice_ids(id)
)
INHERITS(dubsar.practices);
CREATE TABLE dubsar.roles(
	name VARCHAR(255) UNIQUE,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.practice_ids(id)

)
INHERITS(dubsar.practices);
CREATE TABLE dubsar.demeanors(
	user_id BIGINT,
	role_id BIGINT,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES dubsar.practice_ids(id)
)
INHERITS(dubsar.practices);

