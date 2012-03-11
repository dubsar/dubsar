-- Things

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

